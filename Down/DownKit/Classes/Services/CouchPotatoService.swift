//
//  CouchPotatoService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

public class CouchPotatoService: Service {
   
    public static let defaultPort = 8081
    
//    override init() {
//        super.init()
//        
//        refreshSnatchedAndAvailable()
//    }
    
    override public func addListener(listener: ServiceListener) {
        if listener is CouchPotatoListener {
            super.addListener(listener)
        }
    }
    
    override public func startService() {
        
    }
    
    override public func stopService() {
        
    }
    
    // MARK: - Snatched & Available
    
    private func refreshSnatchedAndAvailable() {
        let url = PreferenceManager.couchPotatoHost + "/" + PreferenceManager.couchPotatoApiKey + "/media.list?release_status=snatched,available&limit_offset=20"        
        Alamofire.request(.GET, url).responseJSON { handler in
            if handler.validateResponse() {
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshCompleted()
                })
            }
            else {
                print("Error while fetching CouchPotato snachted and available: \(handler.result.error!)")
            }
        }
    }
    
    private func parseSnatchedAndAvailable(json: JSON!) {
        for _: JSON in json["movies"].array! {
            
        }
    }
    
}
