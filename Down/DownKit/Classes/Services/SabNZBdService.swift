//
//  SabNZBdService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

public class SabNZBdService: Service {
    
    let queueRefreshRate: NSTimeInterval!
    let historyRefreshRate: NSTimeInterval!
    
    var queueRefreshTimer: NSTimer?
    var historyRefreshTimer: NSTimer?
    
    public var queue = Array<SABQueueItem>()
    public var history = Array<SABHistoryItem>()
    public var historySize: Int?
    
    public var currentSpeed: Float?
    public var timeRemaining: String?
    public var mbLeft: Float?
    public var paused: Bool = true
    
    var imdbApiUrl = "http://www.myapifilms.com/imdb"
    var imdbTitleCache = [String: String]()
    
    private enum SabNZBDNotifyType {
        case QueueUpdated
        case HistoryUpdated
        case FullHistoryFetched
        case WillRemoveSabItem
    }
   
    init(queueRefreshRate: NSTimeInterval, historyRefreshRate: NSTimeInterval) {
        self.queueRefreshRate = queueRefreshRate
        self.historyRefreshRate = historyRefreshRate
        
        super.init()
        
        connector = SabNZBdConnector()
        
        startTimers()
    }
    
    override public func addListener(listener: ServiceListener) {
        if listener is SabNZBdListener {
            super.addListener(listener)
        }
    }
    
    override public func checkHostReachability(completion: (Bool) -> (Void)) {
        connector!.validateHost(PreferenceManager.sabNZBdHost) {
            completion($0)
        }
    }
    
    private func startTimers() {
        queueRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(queueRefreshRate, target: self,
            selector: "refreshQueue", userInfo: nil, repeats: true)
        
//        historyRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(historyRefreshRate, target: self,
//            selector: "refreshHistory", userInfo: nil, repeats: true)
        
        refreshQueue()
        refreshHistory()
    }
    
    func difference<S: Equatable>(a: [S], _ b: [S]) -> [S] {
        return a.filter { !b.contains($0) }
    }

    
    // MARK: - Queue
    
    @objc private func refreshQueue() {
        let url = "\(PreferenceManager.sabNZBdHost)?mode=queue&output=json&apikey=\(PreferenceManager.sabNZBdApiKey)"
        
        request(.GET, url).responseJSON { _, _, result in
            if result.isSuccess {
            let responseJson = JSON(result.value!)
                if responseJson["error"] == nil {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        self.parseQueueJson(responseJson)
                        self.refreshCompleted()

                        dispatch_async(dispatch_get_main_queue(), {
                            self.notifyListeners(.QueueUpdated)
                        })
                    })
                }
                else {
                    print("Error while fetching SabNZBd queue: \(responseJson["error"].string!)")
                }
            }
        }
    }
    
    private func parseQueueJson(json: JSON!) {
        let currentQueueIdentifiers = (queue as AnyObject).valueForKey("identifier") as! [String]
        var newQueueIdentifiers = [String]()
        
        // Parse queue
        for jsonJob: JSON in json["queue"]["slots"].array! {
            let identifier = jsonJob["nzo_id"].string!
            let filename = jsonJob["filename"].string!
            let category = jsonJob["cat"].string!
            let nzbName = filename + ".nzb"
            let statusDescription = jsonJob["status"].string!
            let totalMb = jsonJob["mb"].string!.floatValue
            let remainingMb = jsonJob["mbleft"].string!.floatValue
            let timeRemaining = jsonJob["timeleft"].string!
            let progress = jsonJob["percentage"].string!.floatValue
            
            
            let item = findQueueItem(identifier)
            if item == nil {
                queue.append(SABQueueItem(identifier, filename, category, nzbName, statusDescription, totalMb, remainingMb, progress, timeRemaining))
            }
            else {
                item!.update(statusDescription, remainingMb, progress, timeRemaining)
            }
            newQueueIdentifiers.append(identifier)
        }
        
        // Cleanup items removed from queue
        let removedQueueIdentifiers = difference(currentQueueIdentifiers, newQueueIdentifiers)
        removeItemsFromQueue(removedQueueIdentifiers)
        
        // Parse speed, timeleft and mbleft
        currentSpeed = json["queue"]["kbpersec"].string!.floatValue
        timeRemaining = json["queue"]["timeleft"].string!
        mbLeft = json["queue"]["mbleft"].string!.floatValue
        paused = json["queue"]["paused"].bool!
    }
    
    private func findQueueItem(identifier: String) -> SABQueueItem? {
        var queueItem: SABQueueItem?
        
        for item in queue {
            if item.identifier == identifier {
                queueItem = item
                break
            }
        }
        
        return queueItem
    }
    
    private func removeItemFromQueue(identifier: String) {
        if let queueItem = findQueueItem(identifier) {
            notifyListeners(.WillRemoveSabItem, withItem: queueItem)
            queue.removeAtIndex(queue.indexOf(queueItem)!)
        }
    }
    
    private func removeItemsFromQueue(identifiers: [String]) {
        for identifier in identifiers {
            removeItemFromQueue(identifier)
        }
    }
    
    // MARK - History
    
    @objc private func refreshHistory() {
        let url = "\(PreferenceManager.sabNZBdHost)?mode=history&output=json&limit=20&apikey=\(PreferenceManager.sabNZBdApiKey)"
        request(.GET, url).responseJSON { _, _, result in
            if let responseData = result.value {
                let responseJson = JSON(responseData)
                if responseJson["error"] == nil {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        self.parseHistoryJson(responseJson)
                        self.refreshCompleted()

                        dispatch_async(dispatch_get_main_queue(), {
                            self.notifyListeners(.HistoryUpdated)
                        })
                    })
                }
                else {
                    print("Error while fetching SabNZBd history: \(responseJson["error"].string!)")
                }
            }
        }
    }
    
    private var isFetchingHistory = false
    public var fullHistoryFetched: Bool {
        get {
            return self.historySize == self.history.count
        }
    }
    
    public func fetchHistory() {
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
        request(.GET, url).responseJSON { _, _, result in
            if result.isSuccess {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.parseHistoryJson(JSON(result.value!))
                    self.refreshCompleted()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.notifyListeners(.FullHistoryFetched)
                        
                        if self.fullHistoryFetched {
                            self.notifyListeners(.FullHistoryFetched)
                        }
                    })
                })
            }
            else {
                print("Error while fetching : \(result.error!)")
            }
            self.isFetchingHistory = false
        }
        isFetchingHistory = true
    }
    
    private func parseHistoryJson(json: JSON!) {
        let currentHistoryIdentifiers = (history as AnyObject).valueForKey("identifier") as! [String]
        var newHistoryIdentifiers = [String]()
        
        for jsonJob: JSON in json["history"]["slots"].array! {
            let identifier = jsonJob["nzo_id"].string!
            let title = jsonJob["name"].string!
            let filename = jsonJob["nzb_name"].string!
            let category = jsonJob["category"].string!
            let nzbName = jsonJob["nzb_name"].string!
            let size = jsonJob["size"].string!
            let statusDescription = jsonJob["status"].string!
            let actionLine = jsonJob["action_line"].string!
            let completedTimestamp = jsonJob["completed"].int
            let completedDate = NSDate(timeIntervalSince1970: NSTimeInterval(completedTimestamp!))
            
            let item = findHistoryItem(identifier)
            if item == nil {
                let historyItem: SABHistoryItem = SABHistoryItem(identifier, title, filename, category, nzbName, size, statusDescription, actionLine, completedDate)
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
            newHistoryIdentifiers.append(identifier)
        }
        
        // Cleanup items removed from history
        let removedHistoryIdentifiers = difference(currentHistoryIdentifiers, newHistoryIdentifiers)
        removeItemsFromHistory(removedHistoryIdentifiers)
        
        // Parse history size
        historySize = json["history"]["noofslots"].int!
        history.sortInPlace {
            return $0.completionDate!.compare($1.completionDate!) == .OrderedDescending
        }
    }
    
    public func findHistoryItem(imdbIdentifier: String) -> SABHistoryItem? {
        var historyItem: SABHistoryItem?
        
        for item in history {
            if item.identifier == imdbIdentifier {
                historyItem = item
                break
            }
        }
        
        return historyItem
    }
    
    private func removeItemFromHistory(identifier: String) {
        if let historyItem = findHistoryItem(identifier) {
            notifyListeners(.WillRemoveSabItem, withItem: historyItem)
            history.removeAtIndex(history.indexOf(historyItem)!)
        }
    }
    
    private func removeItemsFromHistory(identifiers: [String]) {
        for identifier in identifiers {
            removeItemFromHistory(identifier)
        }
    }
    
    // MARK - Delete items
    
    public func deleteItem(item: SABItem) {
        var mode = "queue"
        if item.isMemberOfClass(SABHistoryItem) {
            mode = "history"
        }
        
        let url = "\(PreferenceManager.sabNZBdHost)?mode=\(mode)&name=delete&value=\(item.identifier)&apikey=\(PreferenceManager.sabNZBdApiKey)"
        request(.GET, url)
    }
    
    // MARK - IMDB
    
    private func fetchTitleFromIMDB(imdbIdentifier: String, completionClosure: (title: String) ->()) {
        if let title = self.imdbTitleCache[imdbIdentifier] as String! {
            completionClosure(title: title)
        }
        else {
            let url = "\(imdbApiUrl)?idIMDB=\(imdbIdentifier)&format=JSON&data=S"            
            request(.GET, url).responseJSON { _, _, result in
                if result.isSuccess {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        let title = JSON(result.value!)["title"].string!
                        self.imdbTitleCache[imdbIdentifier] = title
                        completionClosure(title: title)
                    })
                }
                else {
                    print("Error while fetching IMDB data: \(result.error!)")
                }
            }
        }
    }
    
    // MARK - Listeners
    
    private func notifyListeners(notifyType: SabNZBDNotifyType) {
        for listener in self.listeners {
            if listener is SabNZBdListener {
                let sabNZBdListener = listener as! SabNZBdListener
                switch notifyType {
                case .QueueUpdated:
                    sabNZBdListener.sabNZBdQueueUpdated()
                    break
                case .HistoryUpdated:
                    sabNZBdListener.sabNZBdHistoryUpdated()
                    break
                case .FullHistoryFetched:
                    sabNZBdListener.sabNZBDFullHistoryFetched()
                    break
                default:
                    break
                }
            }
        }
    }
    
    private func notifyListeners(notifyType: SabNZBDNotifyType, withItem sabItem: SABItem) {
        for listener in self.listeners {
            if listener is SabNZBdListener {
                let sabNZBdListener = listener as! SabNZBdListener
                switch notifyType {
                case .WillRemoveSabItem:
                    sabNZBdListener.willRemoveSABItem(sabItem)
                    break
                default:
                    break
                }
            }
        }
    }
    
}
