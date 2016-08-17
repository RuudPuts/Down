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
    let requestManager: Manager
    
    public init() {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.timeoutIntervalForRequest = 1.5
        sessionConfiguration.timeoutIntervalForResource = 1.5
        
        requestManager = Manager(configuration: sessionConfiguration)
    }

    public func validateHost(url: NSURL, completion: (hostValid: Bool, apiKey: String?) -> (Void)) {
        guard url.absoluteString.length > 0 else {
            completion(hostValid: false, apiKey: nil)
            return
        }
        let fixedUrl = url.prefixScheme()
        
        requestManager.request(.GET, fixedUrl).responseString { handler in
            var hostValid = false
            
            if handler.result.isSuccess, let response = handler.response {
                hostValid = self.validateResponseHeaders(response.allHeaderFields)
                if hostValid {
                    // Host is valid
                    self.host = fixedUrl.absoluteString

                    // We got the host, lets fetch the api key
                    self.fetchApiKey {
                        completion(hostValid: hostValid, apiKey: $0)
                    }

                    // fetchApiKey completion handler will call our completion handler
                    return
                }
            }
            
            completion(hostValid: hostValid, apiKey: self.apiKey)
        }
    }
    
    func validateResponseHeaders(headers: [NSObject: AnyObject]) -> Bool {
        let serverHeader = headers["Server"] as? String
        let serverHeaderValid = serverHeader?.hasPrefix("CherryPy") ?? false
        
        let authenticateHeader = headers["Www-Authenticate"] as? String
        let authenticateHeaderValid = authenticateHeader?.rangeOfString("Sickbeard") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    public func fetchApiKey(username username: String = "", password: String = "", completion: (String?) -> (Void)) {
        if let sickbeardHost = host {
            let url = sickbeardHost + "/config/general/"
            
            requestManager.request(.GET, url).authenticate(user: username, password: password).responseString { handler in
                self.apiKey = nil
                
                if handler.result.isSuccess, let html = handler.result.value {
                    self.apiKey = self.extractApiKey(html)
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
    
    func extractApiKey(configHtml: String) -> String? {
        if let apikeyInputRange = configHtml.rangeOfString("id=\"api_key\"") {
            // WARNING: Assumption; api key is within 200 characters from the input id
            let substringLength = 200
            let apikeyIndexEnd = apikeyInputRange.endIndex.advancedBy(substringLength)
            
            if configHtml.endIndex > apikeyIndexEnd {
                let apiKeyRange = apikeyInputRange.endIndex..<apikeyIndexEnd
                let usefullPart = configHtml.substringWithRange(apiKeyRange)
                
                return usefullPart.componentsMatchingRegex("[a-zA-Z0-9]{32}").first
            }
        }
        
        return nil
    }
    
}