//
//  SickbeardService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

class SickbeardService: Service {

    var history: Array<SickbeardHistoryItem>!
    
    enum SickbeardNotifyType {
        case HistoryUpdated
    }
   
    override init() {
        self.history = Array<SickbeardHistoryItem>()
        
        super.init()
        
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
    
    private func refreshHistory() {
        let url = PreferenceManager.sickbeardHost + "/" + PreferenceManager.sickbeardApiKey
        Alamofire.request(.GET, url, parameters: ["cmd": "history", "limit": "40"])
            .responseJSON { (_, _, jsonString, error) in
                if let json: AnyObject = jsonString {
                    self.parseHistoryJson(JSON(json))
                    self.notifyListeners(SickbeardNotifyType.HistoryUpdated)
                    self.refreshCompleted()
                }
        }
    }
    
    private func parseHistoryJson(json: JSON!) {
        var history: Array<SickbeardHistoryItem> = Array<SickbeardHistoryItem>()
        
        for (index: String, jsonItem: JSON) in json["data"] {
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
        for listener in self.listeners as! [SickbeardListener] {
            switch notifyType {
            case .HistoryUpdated:
                listener.sickbeardHistoryUpdated()
            }
        }
    }
    
}
