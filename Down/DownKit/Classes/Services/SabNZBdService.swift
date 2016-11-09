
 //
//  SabNZBdService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class SabNZBdService: Service {
    
    open static let shared = SabNZBdService()
    
    open static let defaultPort = 8080
    
    var queueRefreshRate: TimeInterval = 1 {
        didSet {
            startTimers()
        }
    }
    var historyRefreshRate: TimeInterval = 1 {
        didSet {
            startTimers()
        }
    }
    
    var queueRefreshTimer: Timer?
    var historyRefreshTimer: Timer?
    
    open var queue = [SABQueueItem]()
    open var history = [SABHistoryItem]()
    open var historySize: Int?
    
    open var currentSpeed: Float?
    open var timeRemaining: String?
    open var mbLeft: Float?
    open var paused: Bool = true
    
    var imdbTitleCache = [String: String]()
    
    fileprivate enum SabNZBDNotifyType {
        case queueUpdated
        case historyUpdated
        case fullHistoryFetched
        case willRemoveSabItem
    }
    
    override open func addListener(_ listener: ServiceListener) {
        if listener is SabNZBdListener {
            super.addListener(listener)
        }
    }
    
    override open func startService() {
        super.startService()
        startTimers()
    }
    
    override open func stopService() {
        super.startService()
        stopTimers()
    }
    
    fileprivate func startTimers() {
        guard started else {
            return
        }
        
        queueRefreshTimer?.invalidate()
        historyRefreshTimer?.invalidate()
        
        queueRefreshTimer = Timer.scheduledTimer(timeInterval: queueRefreshRate, target: self, selector: #selector(refreshQueue), userInfo: nil, repeats: true)
        historyRefreshTimer = Timer.scheduledTimer(timeInterval: historyRefreshRate, target: self, selector: #selector(refreshHistory), userInfo: nil, repeats: true)
        
        refreshQueue()
        refreshHistory()
    }
    
    fileprivate func stopTimers() {
        queueRefreshTimer?.invalidate()
        historyRefreshTimer?.invalidate()
    }
    
    func difference<S: Equatable>(_ a: [S], _ b: [S]) -> [S] {
        return a.filter { !b.contains($0) }
    }

    
    // MARK: - Queue
    
    @objc fileprivate func refreshQueue() {
        let url = "\(Preferences.sabNZBdHost)/api?mode=queue&output=json&apikey=\(Preferences.sabNZBdApiKey)"
        
        Alamofire.request(url).responseJSON { handler in
            if handler.validateResponse() {
                let responseJson = JSON(handler.result.value!)
                if responseJson["error"] == JSON.null {
                    DispatchQueue.global().async {
                        self.parseQueueJson(responseJson)
                        self.refreshCompleted()

                        DispatchQueue.main.async {
                            self.notifyListeners(.queueUpdated)
                        }
                    }
                }
                else {
                    print("Error while fetching SabNZBd queue: \(responseJson["error"].string!)")
                }
            }
        }
    }
    
    fileprivate func parseQueueJson(_ json: JSON!) {
        let currentQueueIdentifiers = (queue as AnyObject).value(forKey: "identifier") as! [String]
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
                let timeRemainingString = jsonJob["timeleft"].string!
                let progress = Float(jsonJob["percentage"].string!) ?? 0
                
                // TODO: DateFormatter?
                // Parse time remaining to actual seconds
                // Format 00:00:00
                let timeComponents = timeRemainingString.components(separatedBy: ":")
                let hours = Int(timeComponents[0]) ?? 0
                let minutes = Int(timeComponents[1]) ?? 0
                let seconds = Int(timeComponents[2]) ?? 0
                let timeRemaining = TimeInterval(hours * 3600 + minutes * 60 + seconds)
                
                var item = findQueueItem(identifier)
                if item == nil {
                    item = SABQueueItem(identifier, category, nzbName, statusDescription, totalMb, remainingMb, progress, timeRemaining)
                    queue.append(item!)
                }
                else {
                    item!.update(nzbName, statusDescription, remainingMb, progress, timeRemaining)
                }
                newQueueIdentifiers.append(identifier)
                
                if let imdbIdentifier = item!.imdbIdentifier as String! {
                    fetchTitleFromIMDB(imdbIdentifier, completion: { (title) -> () in
                        item!.imdbTitle = title
                    })
                }
            }
            
            // Cleanup items removed from queue
            let removedQueueIdentifiers = difference(currentQueueIdentifiers, newQueueIdentifiers)
            removeItemsFromQueue(removedQueueIdentifiers)
            
            // Sort the queue
            var unsortedQueue = queue
            unsortedQueue.sort {
                return $0.timeRemaining < $1.timeRemaining
            }
            queue = unsortedQueue
            
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
    
    fileprivate func findQueueItem(_ identifier: String) -> SABQueueItem? {
        var queueItem: SABQueueItem?
        
        for item in queue {
            if item.identifier == identifier {
                queueItem = item
                break
            }
        }
        
        return queueItem
    }
    
    fileprivate func removeItemFromQueue(_ identifier: String) {
        if let queueItem = findQueueItem(identifier) {
            notifyListeners(.willRemoveSabItem, withItem: queueItem)
            queue.remove(at: queue.index(of: queueItem)!)
        }
    }
    
    fileprivate func removeItemsFromQueue(_ identifiers: [String]) {
        for identifier in identifiers {
            removeItemFromQueue(identifier)
        }
    }
    
    // MARK - History
    
    @objc fileprivate func refreshHistory() {
        let url = "\(Preferences.sabNZBdHost)/api?mode=history&output=json&limit=20&apikey=\(Preferences.sabNZBdApiKey)"
        Alamofire.request(url).responseJSON { handler in
            if handler.validateResponse(), let responseData = handler.result.value {
                let responseJson = JSON(responseData)
                if responseJson["error"] == JSON.null {
                    DispatchQueue.global().async {
                        self.parseHistoryJson(responseJson)
                        self.refreshCompleted()

                        DispatchQueue.main.async {
                            self.notifyListeners(.historyUpdated)
                        }
                    }
                }
                else {
                    print("Error while fetching SabNZBd history: \(responseJson["error"].string!)")
                }
            }
        }
    }
    
    fileprivate var isFetchingHistory = false
    open var fullHistoryFetched: Bool {
        get {
            return self.historySize == self.history.count
        }
    }
    
    open func fetchHistory() {
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

        let url = "\(Preferences.sabNZBdHost)/api?mode=history&output=json&start=\(history.count)&limit=20&apikey=\(Preferences.sabNZBdApiKey)"
        
        print("Fetching history \(history.count) - \(history.count + 20)")
        
        Alamofire.request(url).responseJSON { handler in
            if handler.validateResponse() {
                DispatchQueue.global().async {
                    print("Parsing history")
                    self.parseHistoryJson(JSON(handler.result.value!))
                    self.refreshCompleted()
                    
                    DispatchQueue.main.async {
                        self.notifyListeners(.historyUpdated)
                        
                        if self.fullHistoryFetched {
                            self.notifyListeners(.fullHistoryFetched)
                        }
                    }
                }
            }
            else {
                print("Error while fetching : \(handler.result.error!)")
            }
            self.isFetchingHistory = false
        }
        isFetchingHistory = true
    }
    
    fileprivate func parseHistoryJson(_ json: JSON!) {
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
                let completedDate = Date(timeIntervalSince1970: TimeInterval(completedTimestamp!))
                
                let item = findHistoryItem(identifier)
                if item == nil {
                    let historyItem: SABHistoryItem = SABHistoryItem(identifier, title, category, nzbName, size, statusDescription, actionLine, completedDate)
                    history.append(historyItem)
                    
                    if let imdbIdentifier = historyItem.imdbIdentifier as String! {
                        fetchTitleFromIMDB(imdbIdentifier, completion: { (title) -> () in
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
            unsortedHistory.sort {
                return $0.completionDate > $1.completionDate
            }
            history = unsortedHistory
        }
    }
    
    open func findHistoryItem(_ imdbIdentifier: String) -> SABHistoryItem? {
        var historyItem: SABHistoryItem?
        
        for item in history {
            if item.identifier == imdbIdentifier {
                historyItem = item
                break
            }
        }
        
        return historyItem
    }
    
    fileprivate func removeItemFromHistory(_ identifier: String) {
        if let historyItem = findHistoryItem(identifier) {
            notifyListeners(.willRemoveSabItem, withItem: historyItem)
            history.remove(at: history.index(of: historyItem)!)
        }
    }
    
    fileprivate func removeItemsFromHistory(_ identifiers: [String]) {
        for identifier in identifiers {
            removeItemFromHistory(identifier)
        }
    }
    
    // MARK - Delete items
    
    open func deleteItem(_ item: SABItem) {
        var mode = "queue"
        if item is SABHistoryItem {
            mode = "history"
        }
        
        let url = "\(Preferences.sabNZBdHost)/api?mode=\(mode)&name=delete&value=\(item.identifier)&apikey=\(Preferences.sabNZBdApiKey)"
        request(url)
    }
    
    // MARK - IMDB
    
    fileprivate func fetchTitleFromIMDB(_ imdbIdentifier: String, completion: @escaping (_ title: String) ->()) {
        // TODO: Cache data in database, match like sickbeard shows
        if let title = self.imdbTitleCache[imdbIdentifier] as String! {
            completion(title)
        }
        else {
            let url = "http://www.omdbapi.com/?i=\(imdbIdentifier)"
            Alamofire.request(url).responseJSON { handler in
                if handler.validateResponse() {
                    DispatchQueue.global().async {
                        let title = JSON(handler.result.value!)["Title"].string!
                        self.imdbTitleCache[imdbIdentifier] = title
                        completion(title)
                    }
                }
                else {
                    print("Error while fetching IMDB data: \(handler.result.error!)")
                }
            }
        }
    }
    
    // MARK - Listeners
    
    fileprivate func notifyListeners(_ notifyType: SabNZBDNotifyType) {
        for listener in self.listeners {
            if listener is SabNZBdListener {
                let sabNZBdListener = listener as! SabNZBdListener
                switch notifyType {
                case .queueUpdated:
                    sabNZBdListener.sabNZBdQueueUpdated()
                    break
                case .historyUpdated:
                    sabNZBdListener.sabNZBdHistoryUpdated()
                    break
                case .fullHistoryFetched:
                    sabNZBdListener.sabNZBDFullHistoryFetched()
                    break
                default:
                    break
                }
            }
        }
    }
    
    fileprivate func notifyListeners(_ notifyType: SabNZBDNotifyType, withItem sabItem: SABItem) {
        for listener in self.listeners {
            if listener is SabNZBdListener {
                let sabNZBdListener = listener as! SabNZBdListener
                switch notifyType {
                case .willRemoveSabItem:
                    sabNZBdListener.willRemoveSABItem(sabItem)
                    break
                default:
                    break
                }
            }
        }
    }
    
}
