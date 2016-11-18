//
//  SickbeardRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

class SabNZBdRequest: DownRequest {
    
    override internal class func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        let serverHeader = headers["Server"] as? String
        let serverHeaderValid = serverHeader?.hasPrefix("CherryPy") ?? false
        
        let authenticateHeader = headers["Www-Authenticate"] as? String
        let authenticateHeaderValid = authenticateHeader?.range(of: "SABnzbd") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    
    override internal class func validateJson(_ json: JSON) -> (Bool, String?) {
        let error = json["error"]
        
        return (error == JSON.null, error.string)
    }
}
