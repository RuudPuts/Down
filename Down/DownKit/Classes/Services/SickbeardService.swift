//
//  SickbeardService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import RealmSwift
import Alamofire

public class SickbeardService: Service {
    
    public static let defaultPort = 8081

    var refreshTimer: NSTimer?
    
    public var history = Array<SickbeardEpisode>()
    
    // WARN: Shows should be directly fetched from the database
    public var shows = [SickbeardShow]()
    
    var databaseManager: DatabaseManager!
    
    private let bannerDownloadQueue = dispatch_queue_create("com.ruudputs.down.BannerDownloadQueue", DISPATCH_QUEUE_SERIAL)
    private let posterDownloadQueue = dispatch_queue_create("com.ruudputs.down.PosterDownloadQueue", DISPATCH_QUEUE_SERIAL)
    
    private enum SickbeardNotifyType {
        case HistoryUpdated
        case ShowCacheUpdated
    }
   
    override init() {
        super.init()
        databaseManager = DatabaseManager()
    }
    
    override public func addListener(listener: ServiceListener) {
        if listener is SickbeardListener {
            super.addListener(listener)
        }
    }
    
    override public func startService() {
        self.shows = databaseManager.fetchAllSickbeardShows()
        
        NSLog("SickbeardService - Last updated: %@", PreferenceManager.sickbeardLastCacheRefresh ?? "never")
        NSLog("SickbeardService - Refreshing show cache")
        refreshShowCache {
            NSLog("SickbeardService - Show cache refreshed")
            self.startTimers()
        }
    }
    
    override public func stopService() {
        stopTimers()
    }
    
    private func startTimers() {
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(refreshHistory), userInfo: nil, repeats: true)
        
        refreshHistory()
    }
    
    private func stopTimers() {
        refreshTimer?.invalidate()
    }
    
    // MARK: - Public methods
    
    internal func parseNzbName(nzbName: String) -> SickbeardEpisode? {
        // Check if show contains season/episode identifiers
        let regex = try! NSRegularExpression(pattern: "S\\d+E\\d+", options: .CaseInsensitive)
        let seasonRange = regex.rangeOfFirstMatchInString(nzbName, options: [], range: nzbName.fullNSRange) as NSRange!
        
        guard seasonRange.location != NSNotFound else {
            return nil
        }
        
        // Take everything before season/episode identifiers
        let cleanedName = nzbName[0...seasonRange.location - 2]
        
        // Get te components
        let nameComponents = cleanedName.componentsSeparatedByString(".")
        
        // Let the database manager match te best show
        if let show = databaseManager.showBestMatchingComponents(nameComponents) {
            let seasonEpisodeIdentifier = nzbName[seasonRange.location + 1...seasonRange.location + seasonRange.length - 1].uppercaseString
            let components = seasonEpisodeIdentifier.componentsSeparatedByString("E")
            
            let seasonId = Int(components[0])
            let episodeId = Int(components[1])
            
            return show.getEpisode(seasonId!, episodeId!)
        }
        else {
            print("Failed to parse nzb \(nzbName), with show name components \(nameComponents)")
        }
        
        return nil
    }
    
    public func getEpisodesAiringToday() -> Results<SickbeardEpisode> {
        let episodes = databaseManager.episodesAiringOnDate(NSDate());

        for episode in episodes {
            fetchEpisodeData(episode)
        }

        return episodes
    }
    
    public func getEpisodesAiringSoon() -> Results<SickbeardEpisode> {
        let episodes = databaseManager.episodesAiringAfter(NSDate.tomorrow(), max: 5);
        
        for episode in episodes {
            fetchEpisodeData(episode)
        }
        
        return episodes
    }
    
    public func showWithId(tvdbid: Int) -> SickbeardShow? {
        var showWithId: SickbeardShow? = nil
        for show in shows {
            if show.tvdbId == tvdbid {
                showWithId = show
                break
            }
        }
        
        return showWithId
    }
    
    public func refreshEpisodesForShow(show: SickbeardShow) {
        for season in show.seasons {
            for episode in season.episodes {
                fetchEpisodeData(episode)
            }
        }
    }
    
    // MARK: - History
    
    @objc private func refreshHistory() {
        let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=history&limit=40"
        Alamofire.request(.GET, url).responseJSON { handler in
            if handler.validateResponse() {
                dispatch_async(dispatch_get_main_queue(), {
                    self.parseHistoryJson(JSON(handler.result.value!))
                    self.refreshCompleted()
                    
                    self.notifyListeners(.HistoryUpdated)
                })
            }
            else {
                print("Error while fetching Sickbard history: \(handler.result.error!)")
            }
        }
    }
    
    private func parseHistoryJson(json: JSON!) {
        var history: Array<SickbeardEpisode> = Array<SickbeardEpisode>()
        
        for jsonItem: JSON in json["data"].array! {
            let tvdbId = jsonItem["tvdbid"].int!
            
            if let show = showWithId(tvdbId) {
                let season = jsonItem["season"].int!
                let episodeId = jsonItem["episode"].int!
                
                if let episode = show.getEpisode(season, episodeId) {
                    history.append(episode)
                }
            }
        }
        
        self.history = history
    }
    
    // MARK: - Show cache
    
    public func refreshShowCache(completionHandler: () -> Void) {
        if self.shows.count == 0 {
            NSLog("SickbeardService - Refreshing full cache")
            // Find shows to refresh, episodes aired since last update
            let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=shows"
            Alamofire.request(.GET, url).responseJSON { handler in
                if handler.validateResponse() {
                    let showData = (JSON(handler.result.value!)["data"] as JSON).rawValue as! [String: AnyObject]
                    let tvdbIds = Array(showData.keys)
                    self.refreshShowData(tvdbIds, completionHandler: {
                        PreferenceManager.sickbeardLastCacheRefresh = NSDate().dateWithoutTime()
                        completionHandler()
                    })
                }
                else {
                    print("Error while fetching Sickbeard shows list: \(handler.result.error!)")
                }
            }
        }
        else if let lastCacheRefresh = PreferenceManager.sickbeardLastCacheRefresh {
            // Find shows to refresh, episodes aired since last update
            let showsToRefresh = databaseManager.fetchShowsWithEpisodesAiredSince(lastCacheRefresh)
            
            var tvdbIds = [String]()
            for show in showsToRefresh {
                NSLog("SickbeardService - Refreshing \(show.name)")
                tvdbIds.append(String(show.tvdbId))
            }
            
            refreshShowData(tvdbIds, completionHandler: {
                PreferenceManager.sickbeardLastCacheRefresh = NSDate().dateWithoutTime()
                completionHandler()
            })
            
            // TODO: Download shows to remove deleted and add new shows to cache
        }
        else {
            NSLog("SickbeardService - Nothing to do")
        }
    }
    
    private func refreshShowData(tvdbIds: [String], completionHandler: () -> Void) {
        let showMetaDataGroup = dispatch_group_create();
        
        for tvdbId in tvdbIds {
            dispatch_group_enter(showMetaDataGroup)
            
            let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=show&tvdbid=\(tvdbId)"
            Alamofire.request(.GET, url).responseJSON { handler in
                if handler.validateResponse() {
                    self.parseShowData(JSON(handler.result.value!)["data"], forTvdbId: Int(tvdbId)!)
                }
                else {
                    print("Error while fetching Sickbeard showData: \(handler.result.error!)")
                }
                dispatch_group_leave(showMetaDataGroup)
            }
        }
        
        dispatch_group_notify(showMetaDataGroup, dispatch_get_main_queue()) {
            let showSeasonsGroup = dispatch_group_create();
            
            // Only download seasons and episodes for given shows
            let refreshedShows = self.shows.filter({
                tvdbIds.contains(String($0.tvdbId))
            })
            
            for show in refreshedShows {
                self.downloadBanner(show)
                self.downloadPoster(show)
                dispatch_group_enter(showSeasonsGroup)
                self.refreshShowSeasons(show, completionHandler: {
                    var allEpisodes = 0
                    for s in show.seasons {
                        allEpisodes += s.episodes.count
                    }

                    dispatch_group_leave(showSeasonsGroup)
                })
            }
            
            dispatch_group_notify(showSeasonsGroup, dispatch_get_main_queue()) {
                self.databaseManager.storeSickbeardShows(refreshedShows)
                
                completionHandler()
            }
        }
    }
    
    private func parseShowData(json: JSON, forTvdbId tvdbId: Int) {
        let name = json["show_name"].string!
        let paused = json["paused"].int!
        
        let show = SickbeardShow()
        show.tvdbId = tvdbId
        show.name = name
        show.status = paused == 1 ? .Stopped : .Active
        
        if shows.contains(show) {
            // Show is being refreshed
            databaseManager.setStatus(show.status, forShow:showWithId(tvdbId)!)
        }
        else {
            // It's a newly added show
            shows.append(show)
        }
    }
    
    private func refreshShowSeasons(show: SickbeardShow, completionHandler: () -> Void) {
        let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=show.seasons&tvdbid=\(show.tvdbId)"
        Alamofire.request(.GET, url).responseJSON { handler in
            if handler.validateResponse() {
                self.parseShowSeasons(JSON(handler.result.value!)["data"], forShow: show)
                completionHandler()
            }
            else {
                print("Error while fetching Sickbeard showData: \(handler.result.error!)")
            }
        }
    }
    
    private func parseShowSeasons(json: JSON, forShow show: SickbeardShow) {
        let seasons = List<SickbeardSeason>()
        let dateFormatter = NSDateFormatter.downDateFormatter()
        
        let seaonsKeys = Array((json.rawValue as! [String: AnyObject]).keys)
        for seasonKey in seaonsKeys {
            let seasonJson = json[seasonKey] as JSON
        
            let season = SickbeardSeason() //(id: seasonKey, show: show)
            season.id = Int(seasonKey)!
            season.show = show
            
            // Parse season episodes
            let episodeKeys = Array((seasonJson.rawValue as! [String: AnyObject]).keys)
            for episodeKey in episodeKeys {
                let episodeJson = seasonJson[episodeKey] as JSON
                
                let episode = SickbeardEpisode() //(id: episodeKey, season: season, show: show)
                episode.id = Int(episodeKey)!
                episode.name = episodeJson["name"].string!
                episode.airDate = dateFormatter.dateFromString(episodeJson["airdate"].string!)
                episode.quality = episodeJson["quality"].string!
                episode.status = episodeJson["status"].string!
                episode.season = season
                episode.show = show
                
                season._episodes.append(episode)
            }
            
            seasons.append(season)
        }
        show._seasons = seasons
    }
    
    // MARK: - Episodes
    
    private func fetchEpisodeData(episode: SickbeardEpisode) -> Bool {
        guard episode.plot.length == 0 else {
            return false
        }
        
        if let tvdbId = episode.show?.tvdbId, seasonId = episode.season?.id {
            let command = "episode&tvdbid=\(tvdbId)&season=\(seasonId)&episode=\(episode.id)"
            let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=\(command)"
            Alamofire.request(.GET, url).responseJSON { handler in
                if handler.validateResponse() {
                    dispatch_async(dispatch_get_main_queue(), {
                        let plot = JSON(handler.result.value!)["data"]["description"].string ?? ""
                        self.databaseManager.setPlot(plot, forEpisode: episode)
                    })
                }
                else {
                    print("Error while fetching Sickbard history: \(handler.result.error!)")
                }
            }
            
            return true
        }
        
        return false
    }
    
    // MARK: - Listeners
    
    private func notifyListeners(notifyType: SickbeardNotifyType) {
        for listener in self.listeners {
            if listener is SickbeardListener {
                let sickbeardListener = listener as! SickbeardListener
                switch notifyType {
                case .HistoryUpdated:
                    sickbeardListener.sickbeardHistoryUpdated()
                    break
                case .ShowCacheUpdated:
                    break
                }
            }
        }
    }
    
    // MARK: - Banners & Posters
    
    private func downloadBanner(show: SickbeardShow) {
        if show.hasBanner {
            return
        }
        
        dispatch_async(bannerDownloadQueue, {
            
            let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=show.getbanner&tvdbid=\(show.tvdbId)"
            Alamofire.request(.GET, url).responseData { handler in
                if handler.validateResponse() {
                    ImageProvider.storeBanner(handler.result.value!, forShow: show.tvdbId)
                }
                else {
                    print("Error while fetching banner: \(handler.result.error!)")
                }
            }
        })
    }
    
    private func downloadPoster(show: SickbeardShow) {
        if show.hasPoster {
            return
        }
        
        dispatch_async(posterDownloadQueue, {
            let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=show.getposter&tvdbid=\(show.tvdbId)"
            Alamofire.request(.GET, url).responseData { handler in
                // TODO: Store small variant of poster
                
                if handler.validateResponse() {
                    ImageProvider.storePoster(handler.result.value!, forShow: show.tvdbId)
                }
                else {
                    print("Error while fetching poster: \(handler.result.error!)")
                }
            }
        })
    }
    
}
