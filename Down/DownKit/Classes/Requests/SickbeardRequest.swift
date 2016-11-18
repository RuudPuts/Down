//
//  SickbeardRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

class SickbeardRequest: DownRequest {
    
    override class func requestJson(_ url: String, method: DownRequestMethod = .get, parameters: [String: Any]? = nil,
                           succes: @escaping (JSON, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        super.requestJson(url, method: method, parameters: parameters, succes: { json, headers in
            succes(json["data"], headers)
        }, error: error)
    }
    
    override internal class func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        let serverHeader = headers["Server"] as? String
        let serverHeaderValid = serverHeader?.hasPrefix("CherryPy") ?? false
        
        let authenticateHeader = headers["Www-Authenticate"] as? String
        let authenticateHeaderValid = authenticateHeader?.range(of: "Sickbeard") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    
    override internal class func validateJson(_ json: JSON) -> (Bool, String?) {
        let (jsonValid, _) = super.validateJson(json)
        
        return (jsonValid && json["result"].string != "failure", json["message"].string)
    }
    
}
