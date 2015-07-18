//
//  SickbeardService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

class SickbeardService: Service {

    var refreshTimer: NSTimer?
    
    var history: Array<SickbeardHistoryItem>!
    
    enum SickbeardNotifyType {
        case HistoryUpdated
    }
   
    override init() {
        self.history = Array<SickbeardHistoryItem>()
        
        super.init()
        
        startTimers()
    }
    
    override func addListener(listener: Listener) {
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
    
    internal func historyItemWithResource(resource: String!) -> SickbeardHistoryItem? {
        var historyItem: SickbeardHistoryItem?
        for item: SickbeardHistoryItem in self.history {
            if resource.rangeOfString(item.resource) != nil {
                historyItem = item
                break
            }
        }
        return historyItem
    }
    
    // MARK: - History
    
    internal dynamic func refreshHistory() {
        let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey + "?cmd=history&limit=40"
        Alamofire.request(.GET, URLString: url).responseJSON { (_, _, jsonString, error) in
            if let json: AnyObject = jsonString {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    self.parseHistoryJson(JSON(json))
                    self.refreshCompleted()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.notifyListeners(SickbeardNotifyType.HistoryUpdated)
                    })
                })
            }
        }
    }
    
    private func parseHistoryJson(json: JSON!) {
        var history: Array<SickbeardHistoryItem> = Array<SickbeardHistoryItem>()
        
        for jsonItem: JSON in json["data"].array! {
            let tvdbId = jsonItem["tvdbid"].int!
            let showName = jsonItem["show_name"].string!
            let status = jsonItem["status"].string!
            let season = jsonItem["season"].int!
            let episode = jsonItem["episode"].int!
            let resource = jsonItem["resource"].string!
            
            let historyItem = SickbeardHistoryItem(tvdbId, showName, status, season, episode, resource)
            history.append(historyItem)
        }
        
        self.history = history
    }
    
    // MARK - Listeners
    
    private func notifyListeners(notifyType: SickbeardNotifyType) {
        for listener in self.listeners {
            if listener is SickbeardListener {
                let sickbeardListener = listener as! SickbeardListener
                switch notifyType {
                case .HistoryUpdated:
                    sickbeardListener.sickbeardHistoryUpdated()
                }
            }
        }
    }
    
}
