
 //
//  SabNZBdService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

public class SabNZBdService: Service {
    
    public static let defaultPort = 8080
    
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
        connector?.host = PreferenceManager.sabNZBdHost
    }
    
    override public func addListener(listener: ServiceListener) {
        if listener is SabNZBdListener {
            super.addListener(listener)
        }
    }
    
    override public func startService() {
        startTimers()
    }
    
    override public func stopService() {
        stopTimers()
    }
    
    override public func checkHostReachability(host: String, completion: (hostReachable: Bool, requiresAuthentication: Bool) -> (Void)) {
        connector!.validateHost(host) { hostReachable, apiKey in
            if apiKey != nil {
                PreferenceManager.sabNZBdApiKey = apiKey!
            }
            let requiresAuthentication = hostReachable && apiKey == nil
            completion(hostReachable: hostReachable, requiresAuthentication: requiresAuthentication)
        }
    }
    
    override public func checkHostReachability(completion: (hostReachable: Bool, requiresAuthentication: Bool) -> (Void)) {
        connector!.validateHost(PreferenceManager.sabNZBdHost) { hostReachable, apiKey in
            let requiresAuthentication = hostReachable && apiKey == nil
            completion(hostReachable: hostReachable, requiresAuthentication: requiresAuthentication)
        }
    }
    
    private func startTimers() {
        queueRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(queueRefreshRate, target: self, selector: #selector(refreshQueue), userInfo: nil, repeats: true)
        historyRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(historyRefreshRate, target: self, selector: #selector(refreshHistory), userInfo: nil, repeats: true)
        
        refreshQueue()
        refreshHistory()
    }
    
    private func stopTimers() {
        queueRefreshTimer?.invalidate()
        historyRefreshTimer?.invalidate()
    }
    
    func difference<S: Equatable>(a: [S], _ b: [S]) -> [S] {
        return a.filter { !b.contains($0) }
    }

    
    // MARK: - Queue
    
    @objc private func refreshQueue() {
        let url = "\(PreferenceManager.sabNZBdHost)/api?mode=queue&output=json&apikey=\(PreferenceManager.sabNZBdApiKey)"
        
        Alamofire.request(.GET, url).responseJSON { handler in
            if handler.validateResponse() {
                let responseJson = JSON(handler.result.value!)
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
        if let jobs = json["queue"]["slots"].array {
            for jsonJob: JSON in jobs {
                let identifier = jsonJob["nzo_id"].string!
                let category = jsonJob["cat"].string!
                let nzbName = jsonJob["filename"].string! + ".nzb"
                let statusDescription = jsonJob["status"].string!
                let totalMb = Float(jsonJob["mb"].string!) ?? 0
                let remainingMb = Float(jsonJob["mbleft"].string!) ?? 0
                let timeRemaining = jsonJob["timeleft"].string!
                let progress = Float(jsonJob["percentage"].string!) ?? 0
                
                
                var item = findQueueItem(identifier)
                if item == nil {
                    item = SABQueueItem(identifier, category, nzbName, statusDescription, totalMb, remainingMb, progress, timeRemaining)
                    queue.append(item!)
                }
                else {
                    item!.update(statusDescription, remainingMb, progress, timeRemaining)
                }
                newQueueIdentifiers.append(identifier)
                
                if let imdbIdentifier = item!.imdbIdentifier as String! {
                    fetchTitleFromIMDB(imdbIdentifier, completionClosure: { (title) -> () in
                        item!.imdbTitle = title
                    })
                }
            }
            
            // Cleanup items removed from queue
            let removedQueueIdentifiers = difference(currentQueueIdentifiers, newQueueIdentifiers)
            removeItemsFromQueue(removedQueueIdentifiers)
            
            // Parse speed, timeleft and mbleft
            currentSpeed = Float(json["queue"]["kbpersec"].string!) ?? 0
            timeRemaining = json["queue"]["timeleft"].string!
            mbLeft = Float(json["queue"]["mbleft"].string!) ?? 0
            paused = json["queue"]["paused"].bool!
        }
        else {
            currentSpeed = nil
            timeRemaining = nil
            mbLeft = nil
            paused = false
        }
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
        let url = "\(PreferenceManager.sabNZBdHost)/api?mode=history&output=json&limit=20&apikey=\(PreferenceManager.sabNZBdApiKey)"
        Alamofire.request(.GET, url).responseJSON { handler in
            if handler.validateResponse(), let responseData = handler.result.value {
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

        let url = "\(PreferenceManager.sabNZBdHost)/api?mode=history&output=json&start=\(history.count)&limit=20&apikey=\(PreferenceManager.sabNZBdApiKey)"
        
        print("Fetching history \(history.count) - \(history.count + 20)")
        
        Alamofire.request(.GET, url).responseJSON { handler in
            if handler.validateResponse() {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    print("Parsing history")
                    self.parseHistoryJson(JSON(handler.result.value!))
                    self.refreshCompleted()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.notifyListeners(.HistoryUpdated)
                        
                        if self.fullHistoryFetched {
                            self.notifyListeners(.FullHistoryFetched)
                        }
                    })
                })
            }
            else {
                print("Error while fetching : \(handler.result.error!)")
            }
            self.isFetchingHistory = false
        }
        isFetchingHistory = true
    }
    
    private func parseHistoryJson(json: JSON!) {
        if let jobs = json["history"]["slots"].array {
            for jsonJob: JSON in jobs {
                let identifier = jsonJob["nzo_id"].string!
                let title = jsonJob["name"].string!
                let category = jsonJob["category"].string!
                let nzbName = jsonJob["nzb_name"].string!
                let size = jsonJob["size"].string!
                let statusDescription = jsonJob["status"].string!
                let actionLine = jsonJob["action_line"].string!
                let completedTimestamp = jsonJob["completed"].int
                let completedDate = NSDate(timeIntervalSince1970: NSTimeInterval(completedTimestamp!))
                
                let item = findHistoryItem(identifier)
                if item == nil {
                    let historyItem: SABHistoryItem = SABHistoryItem(identifier, title, category, nzbName, size, statusDescription, actionLine, completedDate)
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
            
            // Store history in a new variable, to prevent race conditions of getting items from history while sorting
            var unsortedHistory = history
            unsortedHistory.sortInPlace {
                return $0.completionDate!.compare($1.completionDate!) == .OrderedDescending
            }
            history = unsortedHistory
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
        
        let url = "\(PreferenceManager.sabNZBdHost)/api?mode=\(mode)&name=delete&value=\(item.identifier)&apikey=\(PreferenceManager.sabNZBdApiKey)"
        request(.GET, url)
    }
    
    // MARK - IMDB
    
    private func fetchTitleFromIMDB(imdbIdentifier: String, completionClosure: (title: String) ->()) {
        // TODO: Cache data in database, match like sickbeard shows
        if let title = self.imdbTitleCache[imdbIdentifier] as String! {
            completionClosure(title: title)
        }
        else {
            let url = "http://www.omdbapi.com/?i=\(imdbIdentifier)"
            Alamofire.request(.GET, url).responseJSON { handler in
                if handler.validateResponse() {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        let title = JSON(handler.result.value!)["Title"].string!
                        self.imdbTitleCache[imdbIdentifier] = title
                        completionClosure(title: title)
                    })
                }
                else {
                    print("Error while fetching IMDB data: \(handler.result.error!)")
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
