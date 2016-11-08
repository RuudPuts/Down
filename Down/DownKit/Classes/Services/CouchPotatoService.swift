//
//  CouchPotatoService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

open class CouchPotatoService: Service {
    
    open static let shared = SabNZBdService()
   
    open static let defaultPort = 8081
    
//    override init() {
//        super.init()
//        
//        refreshSnatchedAndAvailable()
//    }
    
    override open func addListener(_ listener: ServiceListener) {
        if listener is CouchPotatoListener {
            super.addListener(listener)
        }
    }
    
    // MARK: - Snatched & Available
    
    fileprivate func refreshSnatchedAndAvailable() {
        let url = PreferenceManager.couchPotatoHost + "/" + PreferenceManager.couchPotatoApiKey + "/media.list?release_status=snatched,available&limit_offset=20"        
        Alamofire.request(url).responseJSON { handler in
            if handler.validateResponse() {
                DispatchQueue.main.async {
                    self.refreshCompleted()
                }
            }
            else {
                print("Error while fetching CouchPotato snachted and available: \(handler.result.error!)")
            }
        }
    }
    
    fileprivate func parseSnatchedAndAvailable(_ json: JSON!) {
        for _: JSON in json["movies"].array! {
            
        }
    }
    
}
