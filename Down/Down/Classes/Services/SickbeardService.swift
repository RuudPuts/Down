//
//  SickbeardService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import Alamofire

class SickbeardService: Service {
   
    init() {
        super.init(baseUrl: "http://192.168.178.10:8081/api", apiKey: "e9c3be0f3315f09d7ceae37f1d3836cd")
        
        refreshHistory()
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
        for (index: String, jsonItem: JSON) in json["data"] {
        }
    }
    
}
