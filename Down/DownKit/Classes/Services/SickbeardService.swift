//
//  SickbeardService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import RealmSwift

public class SickbeardService: Service {

    var refreshTimer: NSTimer?
    
    public var history = Array<SickbeardEpisode>()
    
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
        self.shows = databaseManager.fetchAllSickbeardShows()
        
        NSLog("Last updated: \(PreferenceManager.sickbeardLastCacheRefresh ?? "never")")
        NSLog("Refreshing show cache")
        refreshShowCache {
            NSLog("Show cache refreshed")
            PreferenceManager.sickbeardLastCacheRefresh = NSDate()
            self.startTimers()
        }
    }
    
    override public func addListener(listener: ServiceListener) {
        if listener is SickbeardListener {
            super.addListener(listener)
        }
    }
    
    private func startTimers() {
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "refreshHistory", userInfo: nil, repeats: true)
        
        refreshHistory()
    }
    
    // MARK: - Public methods
    
    internal func episodeWithFilename(filename: String) -> SickbeardEpisode? {
        let episode = databaseManager.episodeWithFilename(filename.stringByReplacingOccurrencesOfString(".nzb", withString: ""))
        
        return episode
    }
    
    public func getEpisodesAiringToday() -> [SickbeardEpisode] {
        let episodes = databaseManager.episodesAiringOnDate(NSDate());

        for e in episodes {
            fetchEpisodeData(e)
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
        request(.GET, url).responseJSON { _, _, result in
            if result.isSuccess {
                dispatch_async(dispatch_get_main_queue(), {
                    self.parseHistoryJson(JSON(result.value!))
                    self.refreshCompleted()
                    
                    self.notifyListeners(.HistoryUpdated)
                })
            }
            else {
                print("Error while fetching Sickbard history: \(result.error!)")
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
                    // Remove the extension from the resource
                    let filename = jsonItem["resource"].string!
                    
                    if episode.filename != filename {
                        databaseManager.setFilename(filename, forEpisode:episode)
                    }
                    history.append(episode)
                }
            }
        }
        
        self.history = history
    }
    
    // MARK: - Show cache
    
    private func refreshShowCache(completionHandler: () -> Void) {
        if self.shows.count == 0 {
            NSLog("Refreshing full cache")
            // Find shows to refresh, episodes aired since last update
            let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=shows"
            request(.GET, url).responseJSON { _, _, result in
                if result.isSuccess {
                    let showData = (JSON(result.value!)["data"] as JSON).rawValue as! [String: AnyObject]
                    let tvdbIds = Array(showData.keys)
                    self.refreshShowData(tvdbIds, completionHandler: {
                        completionHandler()
                    })
                }
                else {
                    print("Error while fetching Sickbeard shows list: \(result.error!)")
                }
            }
        }
        else if let lastCacheRefresh = PreferenceManager.sickbeardLastCacheRefresh {
            // Find shows to refresh, episodes aired since last update
            let showsToRefresh = databaseManager.fetchShowsWithEpisodesAiredSince(lastCacheRefresh)
            
            var tvdbIds = [String]()
            for show in showsToRefresh {
                NSLog("Refreshing \(show.name)")
                tvdbIds.append(String(show.tvdbId))
            }
            
            refreshShowData(tvdbIds, completionHandler: {
                completionHandler()
            })
            
            // TODO: Download shows to remove deleted and add new shows to cache
        }
    }
    
    private func refreshShowData(tvdbIds: [String], completionHandler: () -> Void) {
        let showMetaDataGroup = dispatch_group_create();
        
        for tvdbId in tvdbIds {
            dispatch_group_enter(showMetaDataGroup)
            
            let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=show&tvdbid=\(tvdbId)"
            request(.GET, url).responseJSON { _, _, result in
                if result.isSuccess {
                    self.parseShowData(JSON(result.value!)["data"], forTvdbId: Int(tvdbId)!)
                }
                else {
                    print("Error while fetching Sickbeard showData: \(result.data!)")
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
        request(.GET, url).responseJSON { _, _, result in
            if result.isSuccess {
                self.parseShowSeasons(JSON(result.value!)["data"], forShow: show)
                completionHandler()
            }
            else {
                print("Error while fetching Sickbeard showData: \(result.data!)")
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
        if episode.plot.length > 0 {
            return false
        }
        
        if let tvdbId = episode.show?.tvdbId, seasonId = episode.season?.id {
            let command = "episode&tvdbid=\(tvdbId)&season=\(seasonId)&episode=\(episode.id)"
            let url = PreferenceManager.sickbeardHost + "/api/" + PreferenceManager.sickbeardApiKey + "?cmd=\(command)"
            request(.GET, url).responseJSON { _, _, result in
                if result.isSuccess {
                    dispatch_async(dispatch_get_main_queue(), {
                        let plot = JSON(result.value!)["data"]["description"].string ?? ""
                        self.databaseManager.setPlot(plot, forEpisode: episode)
                    })
                }
                else {
                    print("Error while fetching Sickbard history: \(result.error!)")
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
            request(.GET, url).responseData { _, _, result in
                if result.isSuccess {
                    ImageProvider.storeBanner(result.value!, forShow: show.tvdbId)
                }
                else {
                    print("Error while fetching banner: \(result.error!)")
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
            request(.GET, url).responseData { _, _, result in
                if result.isSuccess {
                    ImageProvider.storePoster(result.value!, forShow: show.tvdbId)
                }
                else {
                    print("Error while fetching poster: \(result.error!)")
                }
            }
        })
    }
    
}
