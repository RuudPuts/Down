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
    
    var currentSpeed: Float?
    var timeRemaining: String?
    var mbLeft: Float?
    var paused: Bool = true
    
    var imdbApiUrl = "http://www.myapifilms.com/imdb"
    var imdbTitleCache = [String: String]()
    
    enum SabNZBDNotifyType {
        case QueueUpdated
        case HistoryUpdated
    }
   
    init(queueRefreshRate: NSTimeInterval, historyRefreshRate: NSTimeInterval) {
        self.queueRefreshRate = queueRefreshRate
        self.historyRefreshRate = historyRefreshRate
        
        super.init()
        
        startTimers()
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
        let parameters = ["mode": "queue", "output": "json", "apikey": PreferenceManager.sabNZBdApiKey] as [String: String]
        Alamofire.request(.GET, PreferenceManager.sabNZBdHost, parameters: parameters)
            .responseJSON { (_, _, jsonString, error) in
                if error == nil {
                    if let json = jsonString as? String {
                        self.parseQueueJson(JSON(json))
                        self.notifyListeners(SabNZBDNotifyType.QueueUpdated)
                        self.refreshCompleted()
                    }
                }
                else {
                    println("Error while fetching SabNZBd queue\n: \(error!)")
                }
        }
    }
    
    private func parseQueueJson(json: JSON!) {
        // Parse queue
        var queue: Array<SABQueueItem> = Array<SABQueueItem>()
        
        for (index: String, jsonJob: JSON) in json["queue"]["slots"] {
            let identifier = jsonJob["nzo_id"].string!
            let filename = jsonJob["filename"].string!
            let category = jsonJob["cat"].string!
            let statusDescription = jsonJob["status"].string!
            let totalMb = jsonJob["mb"].string!.floatValue
            let remainingMb = jsonJob["mbleft"].string!.floatValue
            let totalSize = jsonJob["size"].string!
            let sizeLeft = jsonJob["sizeleft"].string!
            let timeRemaining = jsonJob["timeleft"].string!
            let progress = jsonJob["percentage"].string!.floatValue
            queue.append(SABQueueItem(identifier, filename, category, statusDescription, totalMb, remainingMb, totalSize, sizeLeft, progress, timeRemaining))
        }
        
        self.queue = queue
        
        // Parse speed, timeleft and mbleft
        self.currentSpeed = json["queue"]["kbpersec"].string!.floatValue
        self.timeRemaining = json["queue"]["timeleft"].string!
        self.mbLeft = json["queue"]["mbleft"].string!.floatValue
        self.paused = json["queue"]["paused"].bool!
    }
    
    // MARK - History
    
    internal func refreshHistory() {
        let parameters = ["mode": "history", "output": "json", "limit": 20, "apikey": PreferenceManager.sabNZBdApiKey] as [String: AnyObject]
        Alamofire.request(.GET, PreferenceManager.sabNZBdHost, parameters: parameters)
            .responseJSON { (_, _, jsonString, error) in
                if (error == nil) {
                    if let json: AnyObject = jsonString {
                        self.parseHistoryJson(JSON(json))
                        self.notifyListeners(SabNZBDNotifyType.HistoryUpdated)
                        self.refreshCompleted()
                    }
                }
                else {
                    println("Error while fetching SabNZBd history: \(error!.description)")
                }
        }
    }
    
    private func parseHistoryJson(json: JSON!) {
        for (index: String, jsonJob: JSON) in json["history"]["slots"] {
            let identifier = jsonJob["nzo_id"].string!
            let title = jsonJob["name"].string!
            let filename = jsonJob["nzb_name"].string!
            let category = jsonJob["category"].string!
            let size = jsonJob["size"].string!
            let statusDescription = jsonJob["status"].string!
            let actionLine = jsonJob["action_line"].string!
            
            var item = findHistoryItem(identifier)
            if item == nil {
                let historyItem: SABHistoryItem = SABHistoryItem(identifier, title, filename, category, size, statusDescription, actionLine)
                self.history.append(historyItem)
                
                if let imdbIdentifier = historyItem.imdbIdentifier as String! {
                    fetchTitleFromIMDB(imdbIdentifier, completionClosure: { (title) -> () in
                        historyItem.imdbTitle = title
                    })
                }
            }
        }
    }
    
    private func findHistoryItem(imdbIdentifier: String) -> SABHistoryItem? {
        var historyItem: SABHistoryItem?
        
        for item in history {
            if equal(item.identifier, imdbIdentifier) {
                historyItem = item
                break
            }
        }
        
        return historyItem
    }
    
    // MARK - IMDB
    
    private func fetchTitleFromIMDB(imdbIdentifier: String, completionClosure: (title: String) ->()) {
        if let title = self.imdbTitleCache[imdbIdentifier] as String! {
            completionClosure(title: title)
        }
        else {
            Alamofire.request(.GET, imdbApiUrl, parameters: ["idIMDB": imdbIdentifier, "format": "JSON", "data": "S"])
                .responseJSON { (_, _, jsonString, error) in
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
        for listener in self.listeners as! [SabNZBdListener] {
            
            switch notifyType {
            case .QueueUpdated:
                listener.sabNZBdQueueUpdated()
            case .HistoryUpdated:
                listener.sabNZBdHistoryUpdated()
            }
        }
    }
    
}
