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
   
    init() {
        self.history = Array<SickbeardHistoryItem>()
        
        super.init(baseUrl: "http://192.168.178.10:8081/api", apiKey: "e9c3be0f3315f09d7ceae37f1d3836cd")
        
        refreshHistory()
    }
    
    // MARK: - Public methods
    
    internal func historyItemWithResource(resource: String!) -> SickbeardHistoryItem? {
        var historyItem: SickbeardHistoryItem?
        for item: SickbeardHistoryItem in self.history {
            if item.resource == resource {
                historyItem = item
                break
            }
        }
        return historyItem
    }
    
    // MARK: - History
    
    func refreshHistory() {
        let url = baseUrl + "/" + apiKey
        Alamofire.request(.GET, url, parameters: ["cmd": "history", "limit": "20"])
            .responseJSON { (request, response, jsonString, error) in
                if (jsonString != nil) {
                    var json = JSON(jsonString!)
                    self.parseHistoryJson(json)
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
            
            let historyItem = SickbeardHistoryItem(tvdbId: tvdbId, showName: showName, status: status, season: season, episode: episode, resource: resource)
            history.append(historyItem)
        }
        
        self.history = history
    }
    
}
