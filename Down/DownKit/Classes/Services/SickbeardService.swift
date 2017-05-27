//
//  SickbeardService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import RealmSwift
import Alamofire
import CoreSpotlight

public class SickbeardService: Service {
    
    public static let shared = SickbeardService()
    
    public static let defaultPorts = [8081, 8083]
    fileprivate var shows: Results<SickbeardShow> {
        return DownDatabase.shared.fetchAllSickbeardShows()
    }
    
    fileprivate let bannerDownloadQueue = DispatchQueue(label: "com.ruudputs.down.BannerDownloadQueue", attributes: [])
    fileprivate let posterDownloadQueue = DispatchQueue(label: "com.ruudputs.down.PosterDownloadQueue", attributes: [])
    
    fileprivate var isIndexingSpotlight = false
    
    public enum ErrorType: Int {
        case guardFailed = -1
        case invalidValue = -2
    }
    
    override public func addListener(_ listener: ServiceListener) {
        if listener is SickbeardListener {
            super.addListener(listener)
        }
    }
    
    override public func startService() {
        super.startService()
        reloadSpotlight()
        Log.i("Last updated: \(Preferences.sickbeardLastCacheRefresh ?? Date.init(timeIntervalSince1970: 0))")
        Log.i("Refreshing show cache")
        refreshShowCache()
        
        let defaultShow = SickbeardShow()
        defaultShow.tvdbId = 0
        downloadPoster(defaultShow, force: true)
        downloadBanner(defaultShow, force: true)
    }
    
    // MARK: - Public methods
    
    internal func parseNzbName(_ nzbName: String) -> SickbeardEpisode? {
        // Check if show contains season/episode identifiers
        let regex = try! NSRegularExpression(pattern: "S\\d+(.)?E\\d+", options: .caseInsensitive)
        let seasonRange = regex.rangeOfFirstMatch(in: nzbName, options: [], range: nzbName.fullNSRange) as NSRange!
        
        guard seasonRange?.location != NSNotFound else {
            return nil
        }
        
        // Take everything before season/episode identifiers
        let cleanedName = nzbName.substring(0 ..< (seasonRange?.location)! - 1)
        
        // Get te components
        let nameComponents = cleanedName.components(separatedBy: ".")
        
        // Let the DownDatabase.shared manager match te best show
        if let show = DownDatabase.shared.showBestMatchingComponents(nameComponents) {
            let identifierStart = seasonRange!.location + 1
            let identifierEnd = seasonRange!.location + seasonRange!.length
            let seasonEpisodeIdentifier = nzbName.substring(identifierStart ..< identifierEnd).uppercased().replacingOccurrences(of: ".", with: "")
            let components = seasonEpisodeIdentifier.components(separatedBy: "E")
            
            let seasonId = Int(components.first!)!
            let episodeId = Int(components.last!)!
            
            return show.getSeason(seasonId)?.getEpisode(episodeId)
        }
        else {
//            Log.e("Failed to parse nzb \(nzbName), with show name components \(nameComponents)")
        }
        
        return nil
    }
    
    public func getEpisodesAiringToday() -> Results<SickbeardEpisode> {
        let episodes = DownDatabase.shared.episodesAiringOnDate(Date());

        for episode in episodes {
            fetchEpisodePlot(episode)
        }

        return episodes
    }
    
    public func getEpisodesAiringSoon() -> Results<SickbeardEpisode> {
        let episodes = DownDatabase.shared.episodesAiringAfter(Date.tomorrow(), max: 5);
        
        for episode in episodes {
            fetchEpisodePlot(episode)
        }
        
        return episodes
    }
    
    public func getRecentlyAiredEpisodes() -> Results<SickbeardEpisode> {
        let episodes = DownDatabase.shared.lastAiredEpisodes(maxDays: 4);
        
        for episode in episodes {
            fetchEpisodePlot(episode)
        }
        
        return episodes
    }
    
    public func showWithId(_ tvdbid: Int) -> SickbeardShow? {
        var showWithId: SickbeardShow? = nil
        for show in shows {
            if show.tvdbId == tvdbid && !show.isInvalidated {
                showWithId = show
                break
            }
        }
        
        return showWithId
    }
    
    public func refreshEpisodes(for show: SickbeardShow) {
        for season in show.seasons {
            for episode in season.episodes {
                fetchEpisodePlot(episode)
            }
        }
    }

    // MARK: - Shows
    
    public func refreshShowCache(force: Bool = false) {
        // Find shows to refresh, episodes aired since last update
        fetchShows { tvdbIds in
            if self.shows.count == 0 || force {
                Log.i("Refreshing full cache")
                let shows: [SickbeardShow] = tvdbIds.map {
                    let show = SickbeardShow()
                    show.tvdbId = $0
                    
                    return show
                }
                
                self.refreshShows(shows, completionHandler: {
                    Preferences.sickbeardLastCacheRefresh = Date().withoutTime()
                    self.notifyListeners {
                        Log.i("Show cache refreshed")
                        $0.sickbeardShowCacheUpdated()
                    }
                })
            }
            else if let lastCacheRefresh = Preferences.sickbeardLastCacheRefresh {
                var knownShowIds = Array(self.shows.map { $0.tvdbId })
                
                // Clean up deleted shows
                let deletedShowIds = knownShowIds.filter { !tvdbIds.contains($0) }
                Log.i("Deleted shows: \(deletedShowIds)")
                deletedShowIds.forEach {
                    if let show = self.showWithId($0) {
                        Log.i("SickbeadService - Deleting show: \(show.name)")
                        DownDatabase.shared.deleteSickbeardShow(show)
                        knownShowIds.remove(at: deletedShowIds.index(of: $0)!)
                    }
                }
                
                // Find new shows
                let newShowIds = tvdbIds.filter { !knownShowIds.contains($0) }
                Log.i("New shows: \(newShowIds)")
                
                var showsToRefresh = [SickbeardShow]()
                showsToRefresh += newShowIds.map {
                    let show = SickbeardShow()
                    show.tvdbId = $0
                    
                    return show
                }
                
                // Find shows to refresh, episodes aired since last update
                let recentlyAired = DownDatabase.shared.fetchShowsWithEpisodesAiredSince(lastCacheRefresh)
                for show in recentlyAired {
                    Log.i("Refreshing \(show.name)")
                    showsToRefresh.append(show)
                }
                
                Log.i("Refreshing \(showsToRefresh.count) shows")
                
                self.refreshShows(showsToRefresh) {
                    Preferences.sickbeardLastCacheRefresh = Date().withoutTime()
                    self.notifyListeners {
                        Log.i("Show cache refreshed")
                        $0.sickbeardShowCacheUpdated()
                    }
                }
            }
        }
    }
    
    private func fetchShows(completion: @escaping ([Int]) -> Void) {
        let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=shows"
        SickbeardRequest.requestJson(url, succes: { json, _ in
            let showData = json.rawValue as! [String: AnyObject]
            completion(Array(showData.keys).map { Int($0)! })
        }, error: { error in
           Log.e("Error while fetching Sickbeard shows list: \(error.localizedDescription)")
        })
    }

    public func refreshShow(_ show: SickbeardShow, _ completionHandler: @escaping (SickbeardShow?) -> Void) {
        let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=show&tvdbid=\(show.tvdbId)"
        SickbeardRequest.requestJson(url, succes: { json, _ in
            let refreshedShow = self.parseShowData(json, forTvdbId: show.tvdbId)
            
            self.downloadBanner(refreshedShow)
            self.downloadPoster(refreshedShow)
            self.refreshShowSeasons(refreshedShow, completionHandler: {
                DownDatabase.shared.storeSickbeardShow(refreshedShow)
                Log.i("Refreshed \(refreshedShow.name) (\(refreshedShow.seasons.count) seasons, \(refreshedShow.allEpisodes.count) episodes)")
                
                completionHandler(refreshedShow)
            })
        }, error: { error in
            Log.e("Error while fetching Sickbeard showData: \(error.localizedDescription)")
            completionHandler(nil)
        })
    }
    
    fileprivate func refreshShows(_ shows: [SickbeardShow], completionHandler: @escaping () -> Void) {
        let showRefreshGroup = DispatchGroup();
        
        shows.forEach {
            showRefreshGroup.enter()
            
            refreshShow($0) { _ in
                showRefreshGroup.leave()
            }
        }
        
        showRefreshGroup.notify(queue: DispatchQueue.main) {
            self.reloadSpotlight()
            completionHandler()
        }
    }
    
    public func deleteShow(_ show: SickbeardShow, _ completionHandler: @escaping (Bool) -> Void) {
        let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=show.delete&tvdbid=\(show.tvdbId)"
        SickbeardRequest.requestJson(url, succes: { _ in
            DownDatabase.shared.deleteSickbeardShow(show)
            self.notifyListeners {
                Log.i("Show cache refreshed")
                $0.sickbeardShowCacheUpdated()
            }
            
            completionHandler(true)
        }, error: { _ in
            completionHandler(false)
        })
    }
    
    // MARK: Adding shows
    
    public func addShow(_ show: SickbeardShow, initialState state: SickbeardEpisode.Status, completionHandler: @escaping (Bool, SickbeardShow?) -> Void) -> Void {
        let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=show.addnew&tvdbid=\(show.tvdbId)&status=\(state.rawValue.lowercased())"
        SickbeardRequest.requestJson(url, succes: { json in
            Log.i("Added show \(show.name)")
            self.refreshShowAfterAdd(show) {
                completionHandler(true, $0)
            }
        }, error: { error in
            Log.e("Error while adding show: \(error.localizedDescription)")
            completionHandler(false, nil)
        })
    }
    
    // Don't like having to add this function, but recursive blocks result in a segfault 11
    fileprivate func refreshShowAfterAdd(_ show: SickbeardShow, _ completionHandler: @escaping (SickbeardShow) -> Void) {
        self.refreshShow(show) {
            guard let addedShow = $0 else {
                Log.i("Show still refreshing, retrying")
                Thread.sleep(forTimeInterval: 0.5)
                self.refreshShowAfterAdd(show, completionHandler)
                return
            }
            
            self.downloadBanner(show, force: true)
            self.downloadPoster(show, force: true)
            self.reloadSpotlight()
            
            self.notifyListeners {
                Log.i("Show added: \(show.name)")
                $0.sickbeardShowAdded(show)
            }
            completionHandler(addedShow)
        }
    }
    
    public func searchForShow(query: String, completionHandler: @escaping ([SickbeardShow]) -> Void) {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=sb.searchtvdb&lang=en&name=" + escapedQuery
        SickbeardRequest.requestJson(url, succes: { json, _ in
            let shows = self.parseSearchResults(json["results"])
            completionHandler(shows)
        }, error: { error in
           Log.e("Error while searching Sickbeard shows: \(error.localizedDescription)")
        })
    }
    
    fileprivate func parseSearchResults(_ json: JSON) -> [SickbeardShow] {
        var shows = [SickbeardShow]()
        
        json.forEach { (_, data) in
            let show = SickbeardShow()
            show.tvdbId = data["tvdbid"].int!
            show.name = data["name"].string!
            
            shows.append(show)
        }
        
        return shows
    }
    
    fileprivate func parseShowData(_ json: JSON, forTvdbId tvdbId: Int) -> SickbeardShow {
        let name = json["show_name"].string!
        let status = json["status"].string!
        let quality = json["quality"].string!
        let airs = json["airs"].string!
        let network = json["network"].string!
        
        let show = SickbeardShow()
        show.tvdbId = tvdbId
        show.name = name
        show.status = SickbeardShow.SickbeardShowStatus(rawValue: status) ?? show.status
        show.quality = SickbeardShow.SickbeardShowQuality(rawValue: quality) ?? show.quality
        show.airs = airs
        show.network = network
        
        return show
    }
    
    fileprivate func refreshShowSeasons(_ show: SickbeardShow, completionHandler: @escaping () -> Void) {
        let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=show.seasons&tvdbid=\(show.tvdbId)"
        
        SickbeardRequest.requestJson(url, succes: { json, _ in
            self.parseShowSeasons(json, forShow: show)
            completionHandler()
        }, error: { error in
            Log.e("Error while fetching Sickbeard show seasonData: \(error.localizedDescription)")
            completionHandler()
        })
    }
    
    fileprivate func parseShowSeasons(_ json: JSON, forShow show: SickbeardShow) {
        let seasons = List<SickbeardSeason>()
        let dateFormatter = DateFormatter.downDateFormatter()
        
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
                episode.airDate = dateFormatter.date(from: episodeJson["airdate"].string!)
                episode.quality = episodeJson["quality"].string!
                let status = episodeJson["status"].string!
                episode.status = SickbeardEpisode.Status(rawValue: status) ?? episode.status
                episode.season = season
                episode.show = show
                
                season._episodes.append(episode)
            }
            
            seasons.append(season)
        }
        show._seasons = seasons
    }
    
    // MARK: - Episodes
    
    @discardableResult
    public func fetchEpisodePlot(_ episode: SickbeardEpisode) -> Bool {
        guard episode.plot.length == 0 else {
            return false
        }
        
        if let tvdbId = episode.show?.tvdbId, let seasonId = episode.season?.id {
            let command = "episode&tvdbid=\(tvdbId)&season=\(seasonId)&episode=\(episode.id)"
            let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=\(command)"
            
            SickbeardRequest.requestJson(url, succes: { json, _ in
                DispatchQueue.main.async {
                    let plot = json["description"].string ?? ""
                    DownDatabase.shared.setPlot(plot, forEpisode: episode)
                    self.notifyListeners {
                        Log.i("Episode refreshed: \(episode.show!.name) S\(episode.season!.id)E\(episode.id)")
                        $0.sickbeardEpisodeRefreshed(episode)
                    }
                }
            }, error: { error in
                Log.e("Error while fetching Sickbeard episode data: \(error.localizedDescription)")
            })
            
            return true
        }
        
        return false
    }
    
    public func update(_ status: SickbeardEpisode.Status, forEpisode episode: SickbeardEpisode, completion: @escaping (Error?) -> (Void)) {
        guard let tvdbId = episode.show?.tvdbId, let seasonId = episode.season?.id else {
            completion(NSError(domain: "Down.SickbeardService", code: ErrorType.guardFailed.rawValue, userInfo: [NSLocalizedDescriptionKey: "Guard failed"]))
            return
        }
        
        guard SickbeardEpisode.Status.updatable.contains(status) else {
            completion(NSError(domain: "Down.SickbeardService", code: ErrorType.invalidValue.rawValue, userInfo: [NSLocalizedDescriptionKey: "Invalid value for 'status'"]))
            return
        }
        
        let command = "episode.setstatus&status=\(status.rawValue.lowercased())&tvdbid=\(tvdbId)&season=\(seasonId)&episode=\(episode.id)&force=1"
        let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=\(command)"
        SickbeardRequest.requestJson(url, succes: { _ in
            completion(nil)
        }, error: { error in
            completion(error)
        })
        
        completion(nil)
    }
    
    public func update(_ status: SickbeardEpisode.Status, forSeason season: SickbeardSeason, completion: @escaping (Error?) -> (Void)) {
        guard let tvdbId = season.show?.tvdbId else {
            completion(NSError(domain: "Down.SickbeardService", code: ErrorType.guardFailed.rawValue, userInfo: [NSLocalizedDescriptionKey: "Guard failed"]))
            return
        }
        
        guard SickbeardEpisode.Status.updatable.contains(status) else {
            completion(NSError(domain: "Down.SickbeardService", code: ErrorType.invalidValue.rawValue, userInfo: [NSLocalizedDescriptionKey: "Invalid value for 'status'"]))
            return
        }
        
        let command = "episode.setstatus&status=\(status.rawValue.lowercased())&tvdbid=\(tvdbId)&season=\(season.id)&force=1"
        let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=\(command)"
        SickbeardRequest.requestJson(url, succes: { _ in
            completion(nil)
        }, error: { error in
            completion(error)
        })
        
        completion(nil)
    }
    
    // MARK: - Listeners
    
    fileprivate func notifyListeners(_ task: @escaping ((_ listener: SickbeardListener) -> ())) {
        listeners.forEach { listener in
            if let listener = listener as? SickbeardListener {
                DispatchQueue.main.async {
                    task(listener)
                }
            }
        }
    }
    
    // MARK: - Banners & Posters
    
    fileprivate func downloadBanner(_ show: SickbeardShow) {
        downloadBanner(show, force: false)
    }
    
    fileprivate func downloadBanner(_ show: SickbeardShow, force: Bool) {
        if show.hasBanner && !force {
            return
        }
        
        Log.d("Downloading banner for '\(show.name.length > 0 ? show.name : "Default")'")
        bannerDownloadQueue.async(execute: {
            let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=show.getbanner&tvdbid=\(show.tvdbId)"
            
            SickbeardRequest.requestData(url, succes: { bannerData, _ in
                ImageProvider.storeBanner(bannerData, forShow: show.tvdbId)
            }, error: { error in
                Log.e("Error while fetching banner: \(error.localizedDescription)")
            })
        })
    }
    
    fileprivate func downloadPoster(_ show: SickbeardShow) {
        downloadPoster(show, force: false)
    }
    
    fileprivate func downloadPoster(_ show: SickbeardShow, force: Bool) {
        if show.hasPoster && !force {
            return
        }
        
        Log.d("Downloading poster for '\(show.name.length > 0 ? show.name : "Default")'")
        posterDownloadQueue.async(execute: {
            let url = Preferences.sickbeardHost + "/api/" + Preferences.sickbeardApiKey + "?cmd=show.getposter&tvdbid=\(show.tvdbId)"
            SickbeardRequest.requestData(url, succes: { bannerData, _ in
                ImageProvider.storePoster(bannerData, forShow: show.tvdbId)
                }, error: { error in
                    Log.e("Error while fetching poster: \(error.localizedDescription)")
            })
        })
    }
    
}

// MARK: CoreSpotlight extension

extension SickbeardService { // CoreSpotlight
 
    func reloadSpotlight() {
        guard !isIndexingSpotlight else {
            return
        }
        isIndexingSpotlight = true
        
        DispatchQueue.global().async {
            Log.d("Indexing Spotlight \(Thread.current)");
            
            var items = [CSSearchableItem]()
            self.shows.forEach { show in
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kCIAttributeTypeImage)
                attributeSet.title = show.name
                attributeSet.contentDescription = show.spotlightDescription
                attributeSet.keywords = show.name.components(separatedBy: " ")
                
                if let poster = show.poster {
                    attributeSet.thumbnailData = UIImagePNGRepresentation(poster);
                }
                
                items.append(CSSearchableItem(uniqueIdentifier: "com.ruudputs.down.show.\(show.tvdbId)",
                    domainIdentifier: "com.ruudputs.down", attributeSet: attributeSet))
            }
            
            CSSearchableIndex.default().indexSearchableItems(items) {
                guard $0 == nil else {
                    Log.e("Error while indexing Spotlight: \(String(describing: $0))")
                    return
                }
                
                Log.d("Spotlight indexed \(Thread.current)");
                self.isIndexingSpotlight = false
            };
        }
    }
    
}

extension SickbeardShow { // Spotlight
    
    var spotlightDescription: String {
        var description = "\(self.seasons.count) Seasons, \(self.percentageDownloaded)% available"
        
        if let episode = self.nextAiringEpisode() {
            let airDate = DateFormatter.downDateFormatter().string(from: episode.airDate!)
            description = "Next epsiode: \(airDate) - \(episode.name)"
        }
        
        return description
    }
    
}
