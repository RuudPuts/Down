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
    
    let apiKey: String!
    let queueRefreshRate: NSTimeInterval!
    let historyRefreshRate: NSTimeInterval!
    
    var queueRefreshTimer: NSTimer?
    var historyRefreshTimer: NSTimer?
    
    var queue: Array<SABQueueItem>!
    var history: Array<SABHistoryItem>!
    
    enum SabNZBDNotifyType {
        case QueueUpdated
        case HistoryUpdated
    }
   
    init(queueRefreshRate: NSTimeInterval, historyRefreshRate: NSTimeInterval) {
        self.apiKey = ""
        self.queueRefreshRate = queueRefreshRate
        self.historyRefreshRate = historyRefreshRate
        
        self.queue = Array<SABQueueItem>()
        self.history = Array<SABHistoryItem>()
        
        super.init(baseUrl: "")
        
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
        Alamofire.request(.GET, baseUrl, parameters: ["mode": "qstatus", "output": "json", "apikey": apiKey])
            .responseJSON { (request, response, jsonString, error) in
                var json = JSON(jsonString!)
                self.parseQueueJson(json)
                self.notifyListeners(SabNZBDNotifyType.QueueUpdated)
        }
    }
    
    private func parseQueueJson(json: JSON!) {
        var queue: Array<SABQueueItem> = Array<SABQueueItem>()
        
        for (index: String, jsonJob: JSON) in json["jobs"] {
            queue.append(SABQueueItem(identifier: jsonJob["id"].string!, filename: jsonJob["filename"].string!))
        }
        
        self.queue = queue
    }
    
    // MARK - History
    
    func refreshHistory() {
        Alamofire.request(.GET, baseUrl, parameters: ["mode": "history", "output": "json", "apikey": apiKey])
            .responseJSON { (request, response, jsonString, error) in
                var json = JSON(jsonString!)
                self.parseHistoryJson(json)
                self.notifyListeners(SabNZBDNotifyType.HistoryUpdated)
        }
    }
    
    private func parseHistoryJson(json: JSON!) {
        var history: Array<SABHistoryItem> = Array<SABHistoryItem>()
        
        for (index: String, jsonJob: JSON) in json["history"]["slots"] {
            history.append(SABHistoryItem(identifier: jsonJob["nzo_id"].string!, filename: jsonJob["nzb_name"].string!))
        }
        
        self.history = history
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
