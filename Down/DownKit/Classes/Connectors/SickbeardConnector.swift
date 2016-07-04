//
//  SickbeardConnector.swift
//  Down
//
//  Created by Ruud Puts on 2sx8/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Alamofire

public class SickbeardConnector: Connector {

    public var host: String?
    public var apiKey: String?
    
    public init() {
    }

    public func validateHost(host: String, completion: (hostValid: Bool, apiKey: String?) -> (Void)) {
        guard host.length > 0 else {
            completion(hostValid: false, apiKey: nil)
            return
        }
        
        Alamofire.request(.GET, host).responseJSON { handler in
            var hostValid = false

            // TODO: Create something like a request factory, using the bolts framwork
            if handler.result.isSuccess, let response = handler.response {
                let serverHeader = response.allHeaderFields["Server"] as! String?
                let authenticateHeader = response.allHeaderFields["Www-Authenticate"] as! String?
                if (serverHeader?.hasPrefix("CherryPy") ?? false) || authenticateHeader?.rangeOfString("Sickbeard") != nil {
                    hostValid = true
                    self.host = host

                    // We got the host, lets fetch the api key
                    self.fetchApiKey(username: nil, password: nil, completion: {
                        self.apiKey = $0

                        completion(hostValid: hostValid, apiKey: self.apiKey)
                    })

                    // fetchApiKey completion handler will call our completion handler
                    return
                }
            }
            
            completion(hostValid: hostValid, apiKey: self.apiKey)
        }
    }
    
    public func fetchApiKey(completion: (String?) -> (Void)) {
        fetchApiKey(username: nil, password: nil, completion: completion)
    }
    
    public func fetchApiKey(username username: String?, password: String?, completion: (String?) -> (Void)) {
        if let sabNZBdHost = host {
            var url = "\(sabNZBdHost)/config/general/"
            if username != nil || password != nil {
                let authenticationString = "\(username ?? ""):\(password ?? "")@"
                // TODO: Nope, this is not good :-)
                url = url.insert(authenticationString, atIndex: 7)
            }
            
            Alamofire.request(.GET, url).responseString { response in
                if let html = response.result.value {
                    if let apikeyInputRange = html.rangeOfString("id=\"api_key\"") {
                        // WARNING: Assumption; api key is within 200 characters from the input id
                        let substringLength = 200
                        let apikeyIndexEnd = apikeyInputRange.endIndex.advancedBy(substringLength)
                        
                        if html.endIndex > apikeyIndexEnd {
                            let apiKeyRange = apikeyInputRange.endIndex..<apikeyIndexEnd
                            let usefullPart = html.substringWithRange(apiKeyRange)
                            
                            self.apiKey = usefullPart.componentsMatchingRegex("[a-zA-Z0-9]{32}").first
                        }
                    }
                    else {
                        // TODO: Use some kind of logging
                        NSLog("apikey input not found")
                    }
                }
                
                completion(self.apiKey)
            }
        }
        else {
            // TODO: Use some kind of logging
            NSLog("SabNZBdConnector - Please set host before fetching the api key")
            completion(nil)
        }
    }
    
}