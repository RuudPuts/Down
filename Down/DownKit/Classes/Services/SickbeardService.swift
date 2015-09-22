//
//  SickbeardService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

public class SickbeardService: Service {

    var refreshTimer: NSTimer?
    
    public var history = Array<SickbeardEpisode>()
    public var future: [String: [SickbeardEpisode]]!
    
    public var shows = [String: SickbeardShow]()
    
    private let bannerDownloadQueue = dispatch_queue_create("com.ruudputs.down.BannerDownloadQueue", DISPATCH_QUEUE_SERIAL)
    private let posterDownloadQueue = dispatch_queue_create("com.ruudputs.down.PosterDownloadQueue", DISPATCH_QUEUE_SERIAL)
    
    private enum SickbeardNotifyType {
        case HistoryUpdated
        case FutureUpdated
    }
    
    public enum SickbeardFutureCategory : String {
        case Today = "today", Soon = "soon", Later = "later", Missed = "missed"
        
        static let values = [Today, Soon, Later, Missed]
    }
   
    override init() {
        super.init()
        
        refreshShowCache {
            self.refreshFuture()
            self.startTimers()
        }
    }
    
    override public func addListener(listener: ServiceListener) {
        if listener is SickbeardListener {
            super.addListener(listener)
        }
    }
    
    private func startTimers() {
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self,
            selector: "refreshHistory", userInfo: nil, repeats: true)
        
        refreshHistory()
    }
    
    // MARK: - Public methods
    
    internal func episodeWithFilename(filename: String!) -> SickbeardEpisode? {
        var matchedEpisode: SickbeardEpisode?
        
        for (_, show) in shows {
            for (_, season) in show.seasons {
                for episode in season.episodes {
                    if let episodeFilename = episode.filename {
                        if filename.rangeOfString(episodeFilename) != nil {
                            matchedEpisode = episode
                            break
                        }
                    }
                }
                
                if matchedEpisode != nil {
                    break
                }
            }
        }
        
        return matchedEpisode
    }
    
    // MARK: - History
    
    @objc private func refreshHistory() {
        let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey + "?cmd=history&limit=40"
        request(.GET, url).responseJSON { _, _, result in
            if result.isSuccess {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.parseHistoryJson(JSON(result.value!))
                    self.refreshCompleted()

                    dispatch_async(dispatch_get_main_queue(), {
                        self.notifyListeners(.HistoryUpdated)
                    })
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
            
            if let show = shows[String(tvdbId)] {
                let season = String(jsonItem["season"].int!)
                let episodeId = jsonItem["episode"].int!
                
                if let episode = show.getEpisode(season, episodeId) {
                    // Remove the extension from the resource
                    let resource = jsonItem["resource"].string!
                    var components = resource.componentsSeparatedByString(".")
                    components.removeAtIndex(components.count - 1)
                    
                    episode.filename = components.joinWithSeparator(".")
                    history.append(episode)
                }
            }
        }
        
        self.history = history
    }
    
    // MARK: - Future
    public func refreshFuture() {
        let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey + "?cmd=future"
        request(.GET, url).responseJSON { _, _, result in
            if result.isSuccess {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.parseFuture(JSON(result.value!))
                    self.refreshCompleted()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.notifyListeners(.FutureUpdated)
                    })
                })
            }
            else {
                print("Error while fetching Sickbeard future: \(result.error!)")
            }
        }
    }
    
    private func parseFuture(json: JSON!) {
        var future = [String: [SickbeardEpisode]]()
        
        for category in SickbeardFutureCategory.values {
            let categoryName = category.rawValue as String
            var items = [SickbeardEpisode]()
            
            let categoryItems = json["data"][categoryName].array!
            for jsonItem: JSON in categoryItems {
                let tvdbId = jsonItem["tvdbid"].int!
                
                if let show = shows[String(tvdbId)] {
                    let season = String(jsonItem["season"].int!)
                    let episodeId = jsonItem["episode"].int!
                    
                    if let episode = show.getEpisode(season, episodeId) {
                        items.append(episode)
                    }
                }
            }
            future[categoryName] = items
        }
        
        self.future = future
    }
    
    // MARK: - Show cache
    
    private func refreshShowCache(completionHandler: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey + "?cmd=shows"
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
        })
    }
    
    private func refreshShowData(tvdbIds: [String], completionHandler: () -> Void) {
        let showMetaDataGroup = dispatch_group_create();
        
        for tvdbId in tvdbIds {
            dispatch_group_enter(showMetaDataGroup)
            
            let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey + "?cmd=show&tvdbid=\(tvdbId)"
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
            
            for (_, show) in self.shows {
                self.downloadBanner(show)
                self.downloadPoster(show)
                dispatch_group_enter(showSeasonsGroup)
                self.refreshShowSeasons(show, completionHandler: {
                    dispatch_group_leave(showSeasonsGroup)
                })
            }
            
            dispatch_group_notify(showSeasonsGroup, dispatch_get_main_queue()) {
                completionHandler()
            }
        }
    }
    
    private func parseShowData(json: JSON, forTvdbId tvdbId: Int) {
        let name = json["show_name"].string!
        let paused = json["paused"].int!
        
        let show = SickbeardShow(tvdbId, name, paused)
        self.shows[String(tvdbId)] = show
    }
    
    private func refreshShowSeasons(show: SickbeardShow, completionHandler: () -> Void) {
        let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey + "?cmd=show.seasons&tvdbid=\(show.tvdbId)"
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
        let seaonsKeys = Array((json.rawValue as! [String: AnyObject]).keys)
        for seasonKey in seaonsKeys {
            let seasonJson = json[seasonKey] as JSON
            
            let season = SickbeardSeason(id: seasonKey)
            show.addSeason(season)
            
            let episodeKeys = Array((seasonJson.rawValue as! [String: AnyObject]).keys)
            for episodeKey in episodeKeys {
                let episodeJson = seasonJson[episodeKey] as JSON
                let name = episodeJson["name"].string!
                let airdate = episodeJson["airdate"].string!
                let quality = episodeJson["quality"].string!
                let status = episodeJson["status"].string!
                
                let episode = SickbeardEpisode(episodeKey, name, airdate, quality, status)
                season.addEpisode(episode)
            }
        }
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
                case .FutureUpdated:
                    sickbeardListener.sickbeardFutureUpdated()
                    break
                }
            }
        }
    }
    
    // MARK: - Banners & Posters
    
    private func downloadBanner(show: SickbeardShow) {
        dispatch_async(bannerDownloadQueue, {
            if show.hasBanner {
                return
            }
            
            let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey + "?cmd=show.getbanner&tvdbid=\(show.tvdbId)"
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
        dispatch_async(posterDownloadQueue, {
            if show.hasPoster {
                return
            }
            
            let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey + "?cmd=show.getposter&tvdbid=\(show.tvdbId)"
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
