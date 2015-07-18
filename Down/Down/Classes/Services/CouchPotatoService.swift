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
    
    override func addListener(listener: Listener) {
        if listener is CouchPotatoListener {
            super.addListener(listener)
        }
    }
    
    // MARK: - Snatched & Available
    
    private func refreshSnatchedAndAvailable() {
        let url = PreferenceManager.couchPotatoHost + "/" + PreferenceManager.couchPotatoApiKey + "/media.list?release_status=snatched,available&limit_offset=20"
        Alamofire.request(.GET, URLString: url).responseJSON { (_, _, jsonString, error) in
            if let json: AnyObject = jsonString {
                self.parseSnatchedAndAvailable(JSON(json))
            }
        }
    }
    
    private func parseSnatchedAndAvailable(json: JSON!) {
        for _: JSON in json["movies"].array! {
            
        }
    }
    
}
