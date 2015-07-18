//
//  SabNZBdService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

class SabNZBdService: Service {
    
    let queueRefreshRate: NSTimeInterval!
    let historyRefreshRate: NSTimeInterval!
    
    var queueRefreshTimer: NSTimer?
    var historyRefreshTimer: NSTimer?
    
    var queue = Array<SABQueueItem>()
    var history = Array<SABHistoryItem>()
    var historySize: Int?
    
    var currentSpeed: Float?
    var timeRemaining: String?
    var mbLeft: Float?
    var paused: Bool = true
    
    var imdbApiUrl = "http://www.myapifilms.com/imdb"
    var imdbTitleCache = [String: String]()
    
    enum SabNZBDNotifyType {
        case QueueUpdated
        case HistoryUpdated
        case FullHistoryFetched
    }
   
    init(queueRefreshRate: NSTimeInterval, historyRefreshRate: NSTimeInterval) {
        self.queueRefreshRate = queueRefreshRate
        self.historyRefreshRate = historyRefreshRate
        
        super.init()
        
        startTimers()
    }
    
    override func addListener(listener: Listener) {
        if listener is SabNZBdListener {
            super.addListener(listener)
        }
    }
    
    private func startTimers() {
        queueRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(queueRefreshRate, target: self,
            selector: Selector("refreshQueue"), userInfo: nil, repeats: true)
        
        historyRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(historyRefreshRate, target: self,
            selector: Selector("refreshHistory"), userInfo: nil, repeats: true)
        
        refreshQueue()
        refreshHistory()
    }
    
    // MARK: - Queue
    
    internal func refreshQueue() {
        let url = "\(PreferenceManager.sabNZBdHost)?mode=queue&output=json&apikey=\(PreferenceManager.sabNZBdApiKey)"
        Alamofire.request(.GET, URLString: url).responseJSON { (_, _, jsonString, error) in
            if error == nil {
                if let json: AnyObject = jsonString {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        self.parseQueueJson(JSON(json))
                        self.refreshCompleted()
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.notifyListeners(SabNZBDNotifyType.QueueUpdated)
                        })
                    })
                }
            }
            else {
                print("Error while fetching SabNZBd queue: \(error!)")
            }
        }
    }
    
    private func parseQueueJson(json: JSON!) {
        // Parse queue
        var queue: Array<SABQueueItem> = Array<SABQueueItem>()
        
        for jsonJob: JSON in json["queue"]["slots"].array! {
            let identifier = jsonJob["nzo_id"].string!
            let filename = jsonJob["filename"].string!
            let category = jsonJob["cat"].string!
            let statusDescription = jsonJob["status"].string!
            let totalMb = jsonJob["mb"].string!.floatValue
            let remainingMb = jsonJob["mbleft"].string!.floatValue
            let timeRemaining = jsonJob["timeleft"].string!
            let progress = jsonJob["percentage"].string!.floatValue
            queue.append(SABQueueItem(identifier, filename, category, statusDescription, totalMb, remainingMb, progress, timeRemaining))
        }
        
        self.queue = queue
        
        // Parse speed, timeleft and mbleft
        currentSpeed = json["queue"]["kbpersec"].string!.floatValue
        timeRemaining = json["queue"]["timeleft"].string!
        mbLeft = json["queue"]["mbleft"].string!.floatValue
        paused = json["queue"]["paused"].bool!
    }
    
    // MARK - History
    
    internal func refreshHistory() {        
        let url = "\(PreferenceManager.sabNZBdHost)?mode=history&output=json&limit=20&apikey=\(PreferenceManager.sabNZBdApiKey)"
        Alamofire.request(.GET, URLString: url).responseJSON { (_, _, jsonString, error) in
            if (error == nil) {
                if let json: AnyObject = jsonString {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        self.parseHistoryJson(JSON(json))
                        self.refreshCompleted()

                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.notifyListeners(SabNZBDNotifyType.HistoryUpdated)
                        })
                    })
                }
            }
            else {
                print("Error while fetching SabNZBd history: \(error!.description)")
            }
        }
    }
    
    private var isFetchingHistory = false
    var fullHistoryFetched: Bool {
        get {
            return self.historySize == self.history.count
        }
    }
    internal func fetchHistory() {
        // Don't fetch if already fetching
        if isFetchingHistory || fullHistoryFetched {
            if fullHistoryFetched {
                print("Full history fetched")
            }
            else {
                print("Already busy, skipping history fetch")
            }
            return
        }

        let url = "\(PreferenceManager.sabNZBdHost)?mode=history&output=json&start=\(self.history.count)&limit=20&apikey=\(PreferenceManager.sabNZBdApiKey)"
        Alamofire.request(.GET, URLString: url).responseJSON { (_, _, jsonString, error) in
            if error == nil {
                if let json: AnyObject = jsonString {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        self.parseHistoryJson(JSON(json))
                        self.refreshCompleted()

                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.notifyListeners(SabNZBDNotifyType.HistoryUpdated)

                            if self.fullHistoryFetched {
                                self.notifyListeners(SabNZBDNotifyType.FullHistoryFetched)
                            }
                        })
                    })
                }
            }
            else {
                print("Error while fetching SabNZBd history: \(error!.description)")
            }
            self.isFetchingHistory = false
        }
        isFetchingHistory = true
    }
    
    private func parseHistoryJson(json: JSON!) {
        for jsonJob: JSON in json["history"]["slots"].array! {
            let identifier = jsonJob["nzo_id"].string!
            let title = jsonJob["name"].string!
            let filename = jsonJob["nzb_name"].string!
            let category = jsonJob["category"].string!
            let size = jsonJob["size"].string!
            let statusDescription = jsonJob["status"].string!
            let actionLine = jsonJob["action_line"].string!
            let completedTimestamp = jsonJob["completed"].int
            let completedDate = NSDate(timeIntervalSince1970: NSTimeInterval(completedTimestamp!))
            
            let item = findHistoryItem(identifier)
            if item == nil {
                let historyItem: SABHistoryItem = SABHistoryItem(identifier, title, filename, category, size, statusDescription, actionLine, completedDate)
                history.append(historyItem)
                
                if let imdbIdentifier = historyItem.imdbIdentifier as String! {
                    fetchTitleFromIMDB(imdbIdentifier, completionClosure: { (title) -> () in
                        historyItem.imdbTitle = title
                    })
                }
            }
            else {
                item!.update(category, statusDescription, actionLine, completedDate)
            }
        }
        
        // Parse history size
        historySize = json["history"]["noofslots"].int!
        history.sortInPlace {
            return $0.completionDate!.compare($1.completionDate!) == .OrderedDescending
        }
    }
    
    private func findHistoryItem(imdbIdentifier: String) -> SABHistoryItem? {
        var historyItem: SABHistoryItem?
        
        for item in history {
            if item.identifier == imdbIdentifier {
                historyItem = item
                break
            }
        }
        
        return historyItem
    }
    
    // MARK - Delete items
    
    internal func deleteItem(item: SABItem) {
        var mode = "queue"
        if item.isMemberOfClass(SABHistoryItem) {
            mode = "history"
        }
        
        let url = "\(PreferenceManager.sabNZBdHost)?mode=\(mode)&name=delete&value=\(item.identifier)&apikey=\(PreferenceManager.sabNZBdApiKey)"
        Alamofire.request(.GET, URLString: url)
    }
    
    // MARK - IMDB
    
    private func fetchTitleFromIMDB(imdbIdentifier: String, completionClosure: (title: String) ->()) {
        if let title = self.imdbTitleCache[imdbIdentifier] as String! {
            completionClosure(title: title)
        }
        else {
            let url = "\(imdbApiUrl)?idIMDB=\(imdbIdentifier)&format=JSON&data=S"
            Alamofire.request(.GET, URLString: url).responseJSON { (_, _, jsonString, _) in
                if let json: AnyObject = jsonString {
                    let title = JSON(json)["title"].string!
                    self.imdbTitleCache[imdbIdentifier] = title
                    completionClosure(title: title)
                }
            }
        }
    }
    
    // MARK - Listeners
    
    private func notifyListeners(notifyType: SabNZBDNotifyType) {
        for listener in listeners as! [SabNZBdListener] {
            
            switch notifyType {
            case .QueueUpdated:
                listener.sabNZBdQueueUpdated()
            case .HistoryUpdated:
                listener.sabNZBdHistoryUpdated()
            case .FullHistoryFetched:
                listener.sabNZBDFullHistoryFetched()
            }
        }
    }
    
}
