//
//  CouchPotatoService.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Alamofire

public class CouchPotatoService: Service {
    
    public static let shared = SabNZBdService()
   
    public static let defaultPorts = [5050]
    
    override public func addListener(_ listener: ServiceListener) {
        if listener is CouchPotatoListener {
            super.addListener(listener)
        }
    }
    
    // MARK: - Snatched & Available
    
    fileprivate func refreshSnatchedAndAvailable() {
        let url = Preferences.couchPotatoHost + "/" + Preferences.couchPotatoApiKey + "/media.list?release_status=snatched,available&limit_offset=20"
        DownRequest.requestJson(url, succes: { json in
            self.refreshCompleted()
        }, error: { error in
            Log.e("Error while fetching CouchPotato snachted and available: \(error.localizedDescription)")
        })
    }
    
    fileprivate func parseSnatchedAndAvailable(_ json: JSON!) {
    }
    
}
