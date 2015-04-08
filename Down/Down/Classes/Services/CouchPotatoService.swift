//
//  CouchPotatoService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

class CouchPotatoService: Service {
   
    init() {
        super.init(baseUrl: "http://192.168.178.10:5050/api", apiKey: "fb3f91e38ba147b29514d56a24d17d9a")
        
        refreshSnatchedAndAvailable()
    }
    
    // MARK: - Snatched & Available
    
    func refreshSnatchedAndAvailable() {
        let url = baseUrl + "/" + apiKey + "/media.list"
        Alamofire.request(.GET, url, parameters: ["release_status": "snatched,available", "limit_offset": "20"])
            .responseJSON { (request, response, jsonString, error) in
                if (jsonString != nil) {
                    var json = JSON(jsonString!)
                    self.parseSnatchedAndAvailable(json)
                }
        }
    }
    
    private func parseSnatchedAndAvailable(json: JSON!) {
        for (index: String, jsonItem: JSON) in json["movies"] {
        }
    }
    
}
