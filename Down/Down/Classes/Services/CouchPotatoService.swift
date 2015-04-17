//
//  CouchPotatoService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

class CouchPotatoService: Service {
   
    override init() {
        super.init()
        
        refreshSnatchedAndAvailable()
    }
    
    // MARK: - Snatched & Available
    
    private func refreshSnatchedAndAvailable() {
        let url = PreferenceManager.couchPotatoHost + "/" + PreferenceManager.couchPotatoApiKey + "/media.list"
        Alamofire.request(.GET, url, parameters: ["release_status": "snatched,available", "limit_offset": "20"])
            .responseJSON { (_, _, jsonString, error) in
                if let json: AnyObject = jsonString {
                    self.parseSnatchedAndAvailable(JSON(json))
                }
        }
    }
    
    private func parseSnatchedAndAvailable(json: JSON!) {
        for (index: String, jsonItem: JSON) in json["movies"] {
        }
    }
    
}
