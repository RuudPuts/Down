//
//  SabNZBdConnector.swift
//  Down
//
//  Created by Ruud Puts on 18/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

public class SabNZBdConnector: Connector {

    public func validateHost(host: String, completion: (Bool) -> (Void)) {
        let url = "http://\(host)"
        request(.GET, url).responseString { _, urlResponse, responseString in
            var hostValid = false
            
            if let response = urlResponse {
                NSLog("%@ - %@", "SabNZBdConnector", response ?? "No reponse")
            }
            
            completion(hostValid)
        }
    }
    
}
