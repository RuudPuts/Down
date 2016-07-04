//
//  Connector.swift
//  Down
//
//  Created by Ruud Puts on 18/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Alamofire

public protocol Connector {
    
    var host: String? { get set }
    var apiKey: String? { get set }
    
    func validateHost(host: String, completion: (hostValid: Bool, apiKey: String?) -> (Void))
    
    func fetchApiKey(completion: (String?) -> (Void))
    func fetchApiKey(username username: String?, password: String?, completion: (String?) -> (Void))
    
    // TODO: Add some generic fetch method, to prevent overhead in services
    
}

extension Response {

    func validateResponse() -> Bool {
        let resultSuccess = result.isSuccess
        let responseValid = response != nil
        let returnCodeValid = response?.statusCode < 400
        
        return resultSuccess && responseValid && returnCodeValid
    }
    
}