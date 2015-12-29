//
//  SickbeardConnector.swift
//  Down
//
//  Created by Ruud Puts on 2sx8/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

public class SickbeardConnector: Connector {

    public var requestManager: Manager?
    public var host: String?
    public var apiKey: String?
    
    public init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        
        requestManager = Manager(configuration: configuration)
    }

    public func validateHost(host: String, completion: (hostValid: Bool, apiKey: String?) -> (Void)) {
        requestManager!.request(.GET, host).responseString { _, urlResponse, _ in
            var hostValid = false
            
            if let response = urlResponse {
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
            
            requestManager!.request(.GET, url).responseString { _, urlResponse, reponseString in
                if let html = reponseString.value {
                    if let apikeyInputRange = html.rangeOfString("id=\"api_key\"") {
                        // WARN: Assumption; api key is within 200 characters from the input id
                        let substringLength = 200
                        let apikeyIndexEnd = apikeyInputRange.endIndex.advancedBy(substringLength)
                        
                        if html.endIndex > apikeyIndexEnd {
                            let apiKeyRange = Range(start:apikeyInputRange.endIndex, end:apikeyIndexEnd)
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