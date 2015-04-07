//
//  SabNZBdService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import Alamofire

class SabNZBdService: Service {
    
    let queueRefreshRate: NSTimeInterval!
    let historyRefreshRate: NSTimeInterval!
    
    var queueRefreshTimer: NSTimer?
    var historyRefreshTimer: NSTimer?
    
    var queue: Array<SABQueueItem>!
    var history: Array<SABHistoryItem>!
    
    var currentSpeed: Float?
    var timeRemaining: String?
    var mbLeft: Float?
    var paused: Bool?
    
    var imdbApiUrl = "http://www.myapifilms.com/imdb"
    var imdbTitleCache = [String: String]()
    
    enum SabNZBDNotifyType {
        case QueueUpdated
        case HistoryUpdated
    }
   
    init(queueRefreshRate: NSTimeInterval, historyRefreshRate: NSTimeInterval) {
        self.queueRefreshRate = queueRefreshRate
        self.historyRefreshRate = historyRefreshRate
        
        self.queue = Array<SABQueueItem>()
        self.history = Array<SABHistoryItem>()
        
        super.init(baseUrl: "http://192.168.178.10:8080/api", apiKey: "49b77b422da54f699a58562f3a1debaa")
        
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
    
    func refreshQueue() {
        Alamofire.request(.GET, baseUrl, parameters: ["mode": "queue", "output": "json", "apikey": apiKey])
            .responseJSON { (request, response, jsonString, error) in
                if (jsonString != nil) {
                    var json = JSON(jsonString!)
                    self.parseQueueJson(json)
                    self.notifyListeners(SabNZBDNotifyType.QueueUpdated)
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
            let status = jsonJob["status"].string!
            let totalMb = jsonJob["mb"].string!.floatValue
            let remainingMb = jsonJob["mbleft"].string!.floatValue
            let totalSize = jsonJob["size"].string!
            let sizeLeft = jsonJob["sizeleft"].string!
            let timeRemaining = jsonJob["timeleft"].string!
            let progress = jsonJob["percentage"].string!.floatValue
            queue.append(SABQueueItem(identifier: identifier, filename: filename, category: category, status:status, totalMb: totalMb, remainingMb: remainingMb, totalSize: totalSize, sizeLeft: sizeLeft, progress: progress, timeRemaining: timeRemaining))
        }
        
        self.queue = queue
        
        // Parse speed, timeleft and mbleft
        self.currentSpeed = json["queue"]["kbpersec"].string!.floatValue
        self.timeRemaining = json["queue"]["timeleft"].string!
        self.mbLeft = json["queue"]["mbleft"].string!.floatValue
        self.paused = json["queue"]["paused"].bool!
    }
    
    // MARK - History
    
    func refreshHistory() {
        Alamofire.request(.GET, baseUrl, parameters: ["mode": "history", "output": "json", "limit": 20, "apikey": apiKey])
            .responseJSON { (request, response, jsonString, error) in
                if (jsonString != nil) {
                    var json = JSON(jsonString!)
                    self.parseHistoryJson(json)
                    self.notifyListeners(SabNZBDNotifyType.HistoryUpdated)
                }
        }
    }
    
    private func parseHistoryJson(json: JSON!) {
        var history: Array<SABHistoryItem> = Array<SABHistoryItem>()
        
        for (index: String, jsonJob: JSON) in json["history"]["slots"] {
            let identifier = jsonJob["nzo_id"].string!
            let filename = jsonJob["nzb_name"].string!
            let category = jsonJob["category"].string!
            let size = jsonJob["size"].string!
            let status = jsonJob["status"].string!
            
            let historyItem: SABHistoryItem = SABHistoryItem(identifier: identifier, filename: filename, category: category, size: size, status: status)
            history.append(historyItem)
            
            let imdbIdentifier: String? = historyItem.imdbIdentifier
            if (imdbIdentifier != nil) {
                fetchTitleFromIMDB(imdbIdentifier!, completionClosure: { (title) -> () in
                    historyItem.imdbTitle = title
                })
            }
        }
        self.history = history
    }
    
    // MARK - IMDB
    
    func fetchTitleFromIMDB(imdbIdentifier: String, completionClosure: (title: String) ->()) {
        var title = self.imdbTitleCache[imdbIdentifier] as String?
        if (title != nil) {
            completionClosure(title: title!)
        }
        else {
            Alamofire.request(.GET, imdbApiUrl, parameters: ["idIMDB": imdbIdentifier, "format": "JSON", "data": "S"])
                .responseJSON { (request, response, jsonString, error) in
                    if (jsonString != nil) {
                        var json = JSON(jsonString!)
                        
                        title = json["title"].string!
                        self.imdbTitleCache[imdbIdentifier] = title
                        completionClosure(title: title!)
                    }
            }
        }
    }
    
    // MARK - Listeners
    
    private func notifyListeners(notifyType: SabNZBDNotifyType) {
        for listener: Listener in self.listeners {
            let sabNZBdListener = listener as SabNZBdListener
            
            switch notifyType {
            case .QueueUpdated:
                sabNZBdListener.sabNZBdQueueUpdated()
            case .HistoryUpdated:
                sabNZBdListener.sabNZBdHistoryUpdated()
            }
        }
    }
    
}
