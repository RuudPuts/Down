//
//  SickbeardRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

class SabNZBdRequest: DownRequest {
    
    override class func requestString(_ url: String, succes: @escaping (String, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        super.requestString(url, succes: { response, headers in
            guard validateResponseHeaders(headers) else {
                error(downRequestError(message: "Host returned invalid headers"))
                return
            }
            
            succes(response, headers)
        }, error: error)
    }
    
    private class func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        let serverHeader = headers["Server"] as? String
        let serverHeaderValid = serverHeader?.hasPrefix("CherryPy") ?? false
        
        let authenticateHeader = headers["Www-Authenticate"] as? String
        let authenticateHeaderValid = authenticateHeader?.range(of: "SABnzbd") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    
}
