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


public class SabNZBdService: Service {
    
    public static let shared = SabNZBdService()
    
    public static let defaultPorts = [8080]
    
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
    
    public var queue = [SABQueueItem]()
    public var history = [SABHistoryItem]()
    public var historySize: Int?
    
    public var currentSpeed: Double?
    public var timeRemaining: String?
    public var mbLeft: Double?
    public var paused: Bool = true
    
    var imdbTitleCache = [String: String]()
    
    override public func addListener(_ listener: ServiceListener) {
        if listener is SabNZBdListener {
            super.addListener(listener)
        }
    }
    
    override public func startService() {
        super.startService()
        startTimers()
    }
    
    override public func stopService() {
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
        
        SabNZBdRequest.requestJson(url, succes: { json, _ in
            DispatchQueue.global().async {
                self.parseQueueJson(json)
                self.refreshCompleted()
                
                self.notifyListeners { $0.sabNZBdQueueUpdated() }
            }
        }, error: { error in
            Log.e("[SabNZBdService] Error while fetching queue: \(error.localizedDescription)")
        })
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
                let totalMb = Double(jsonJob["mb"].string!) ?? 0
                let remainingMb = Double(jsonJob["mbleft"].string!) ?? 0
                let timeRemaining = jsonJob["timeleft"].string?.timeToSeconds() ?? 0.0
                let progress = Double(jsonJob["percentage"].string!) ?? 0
                
                var item = findQueueItem(identifier)
                if item == nil {
                    item = SABQueueItem(identifier, category, nzbName, statusDescription, totalMb, remainingMb, progress, timeRemaining)
                    queue.append(item!)
                }
                else {
                    item!.update(nzbName, statusDescription, totalMb, remainingMb, progress, timeRemaining)
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
            currentSpeed = Double(json["queue"]["kbpersec"].string!) ?? 0
            timeRemaining = json["queue"]["timeleft"].string!
            mbLeft = Double(json["queue"]["mbleft"].string!) ?? 0
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
            notifyListeners{ $0.willRemoveSABItem(queueItem) }
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
        SabNZBdRequest.requestJson(url, succes: { json, _ in
            DispatchQueue.global().async {
                self.parseHistoryJson(json)
                self.refreshCompleted()
                
                self.notifyListeners { $0.sabNZBdHistoryUpdated() }
            }
        }, error: { error in
            Log.e("[SabNZBdService] Error while refreshing history: \(error.localizedDescription)")
        })
    }
    
    fileprivate var isFetchingHistory = false
    public var fullHistoryFetched: Bool {
        get {
            return self.historySize == self.history.count
        }
    }
    
    public func fetchHistory() {
        // Don't fetch if already fetching
        if isFetchingHistory || fullHistoryFetched {
            if fullHistoryFetched {
                Log.i("Full history fetched")
            }
            else {
                Log.i("Already busy, skipping history fetch")
            }
            return
        }

        let url = "\(Preferences.sabNZBdHost)/api?mode=history&output=json&start=\(history.count)&limit=20&apikey=\(Preferences.sabNZBdApiKey)"
        
        Log.i("Fetching history \(history.count) - \(history.count + 20)")
        SabNZBdRequest.requestJson(url, succes: { json, _ in
            DispatchQueue.global().async {
                self.parseHistoryJson(json)
                self.refreshCompleted()
                
                self.notifyListeners {
                    $0.sabNZBdHistoryUpdated()
                    if self.fullHistoryFetched {
                        $0.sabNZBDFullHistoryFetched()
                    }
                }
                self.isFetchingHistory = false
                
            }
        }, error: { error in
            Log.e("[SabNZBdService] Error while fetching history: \(error.localizedDescription)")
            self.isFetchingHistory = false
        })
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
    
    public func findHistoryItem(_ imdbIdentifier: String) -> SABHistoryItem? {
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
            notifyListeners{ $0.willRemoveSABItem(historyItem) }
            history.remove(at: history.index(of: historyItem)!)
        }
    }
    
    fileprivate func removeItemsFromHistory(_ identifiers: [String]) {
        for identifier in identifiers {
            removeItemFromHistory(identifier)
        }
    }
    
    // MARK - Delete items
    
    public func deleteItem(_ item: SABItem) {
        var mode = "queue"
        if item is SABHistoryItem {
            mode = "history"
        }
        
        let url = "\(Preferences.sabNZBdHost)/api?mode=\(mode)&name=delete&value=\(item.identifier!)&apikey=\(Preferences.sabNZBdApiKey)"
        SabNZBdRequest.requestString(url, succes: { response, _ in
            if let historyItem = item as? SABHistoryItem, let historyIndex = self.history.index(of: historyItem) {
                self.history.remove(at: historyIndex)
            }
            
            if let queueItem = item as? SABQueueItem, let queueIndex = self.queue.index(of: queueItem) {
                self.queue.remove(at: queueIndex)
            }
            
            self.notifyListeners{ $0.willRemoveSABItem(item) }
        }, error: { error in
            Log.e("[SabNZBdService] Error while deleting item: \(error.localizedDescription)")
        })
    }
    
    // MARK - IMDB
    
    fileprivate func fetchTitleFromIMDB(_ imdbIdentifier: String, completion: @escaping (_ title: String) ->()) {
        // TODO: Cache data in database, match like sickbeard shows
        if let title = self.imdbTitleCache[imdbIdentifier] as String! {
            completion(title)
        }
        else {
            let url = "https://api.themoviedb.org/3/find/\(imdbIdentifier)?api_key=f1849f09c4fccb34a2e5fafc5decf31f&language=en-US&external_source=imdb_id"
            DownRequest.requestJson(url, succes: { json, _ in
                DispatchQueue.global().async {
                    if let title = json["movie_results"].array?.first?["original_title"].string {
                        self.imdbTitleCache[imdbIdentifier] = title
                        completion(title)
                    }
                }
            }, error: { error in
                Log.e("[SabNZBdService] Error while fetching IMDB data: \(error.localizedDescription)")
            })
        }
    }
    
    // MARK - Listeners
    
    fileprivate func notifyListeners(_ task: @escaping ((_ listener: SabNZBdListener) -> ())) {
        listeners.forEach { listener in
            if let listener = listener as? SabNZBdListener {
                DispatchQueue.main.async {
                    task(listener)
                }
            }
        }
    }
}
