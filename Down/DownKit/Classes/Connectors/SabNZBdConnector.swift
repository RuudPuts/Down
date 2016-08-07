//
//  SabNZBdConnector.swift
//  Down
//
//  Created by Ruud Puts on 18/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Alamofire

public class SabNZBdConnector: Connector {

    public var host: String?
    public var apiKey: String?

    // TODO: Set request timeouts
    public init() {
//        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.timeoutIntervalForRequest = 1
//        configuration.timeoutIntervalForResource = 1
//        
//        requestManager = Manager(configuration: configuration)
    }

    public func validateHost(host: String, completion: (hostValid: Bool, apiKey: String?) -> (Void)) {
        guard host.length > 0 else {
            completion(hostValid: false, apiKey: nil)
            return
        }
        
        Alamofire.request(.GET, host).responseString { handler in
            var hostValid = false
            
            if handler.result.isSuccess, let response = handler.response {
                let serverHeader = response.allHeaderFields["Server"] as! String?
                let authenticateHeader = response.allHeaderFields["Www-Authenticate"] as! String?
                if serverHeader?.hasPrefix("CherryPy") ?? false || authenticateHeader?.rangeOfString("SABnzbd") != nil {
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
            
            Alamofire.request(.GET, url).responseString { handler in
                if handler.result.isSuccess, let html = handler.result.value {
                    if let apikeyInputRange = html.rangeOfString("id=\"apikey\"") {
                        // WARN: Assumption; api key is within 200 characters from the input id
                        let substringLength = 200
                        let apikeyIndexEnd = apikeyInputRange.endIndex.advancedBy(substringLength)
                        
                        if html.endIndex > apikeyIndexEnd {
                            let apiKeyRange = apikeyInputRange.endIndex..<apikeyIndexEnd
                            let usefullPart = html.substringWithRange(apiKeyRange)
                            
                            self.apiKey = usefullPart.componentsMatchingRegex("[a-zA-Z0-9]{32}").first
                        }
                    }
                    else {
                        NSLog("apikey input not found")
                    }
                }
                
                completion(self.apiKey)
            }
        }
        else {
            NSLog("SabNZBdConnector - Please set host before fetching the api key")
            completion(nil)
        }
    }
    
}