//
//  SickbeardRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

class SickbeardRequest: DownRequest {
    
    override class func requestJson(_ url: String, succes: @escaping (JSON, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        super.requestJson(url, succes: { json, headers in
            guard verifyJson(json) else {
                error(downRequestError(message: json["message"].string ?? ""))
                return
            }
            
            succes(json["data"], headers)
        }, error: error)
    }
    
    private class func verifyJson(_ json: JSON) -> Bool {
        return json["result"].string != "failure"
    }
    
}
