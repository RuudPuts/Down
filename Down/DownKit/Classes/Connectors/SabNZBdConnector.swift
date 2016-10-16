//
//  SabNZBdConnector.swift
//  Down
//
//  Created by Ruud Puts on 18/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Alamofire

open class SabNZBdConnector: Connector {

    open var host: String?
    open var apiKey: String?
    let requestManager: Manager
    
    public init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 2
        sessionConfiguration.timeoutIntervalForResource = 2
        
        requestManager = Manager(configuration: sessionConfiguration)
    }

    open func validateHost(_ url: URL, completion: @escaping (_ hostValid: Bool, _ apiKey: String?) -> (Void)) {
        guard url.absoluteString.length > 0 else {
            completion(false, nil)
            return
        }
        let fixedUrl = url.prefixScheme()
        
        requestManager.request(fixedUrl).responseString { handler in
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
    
    func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        let serverHeader = headers["Server"] as? String
        let serverHeaderValid = serverHeader?.hasPrefix("CherryPy") ?? false
        
        let authenticateHeader = headers["Www-Authenticate"] as? String
        let authenticateHeaderValid = authenticateHeader?.range(of: "SABnzbd") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    
    open func fetchApiKey(username: String = "", password: String = "", completion: @escaping (String?) -> (Void)) {
        if let sabNZBdHost = host {
            let url = sabNZBdHost + "/config/general/"
            
            requestManager.request(url).authenticate(user: username, password: password).responseString { handler in
                self.apiKey = nil
                
                if handler.result.isSuccess, let html = handler.result.value {
                    self.apiKey = self.extractApiKey(html)
                }
                
                completion(self.apiKey)
            }
        }
        else {
            NSLog("SabNZBdConnector - Please set host before fetching the api key")
            completion(nil)
        }
    }
    
    func extractApiKey(_ configHtml: String) -> String? {
        if let apikeyInputRange = configHtml.range(of: "id=\"apikey\"") {
            // WARN: Assumption; api key is within 200 characters from the input id
            let substringLength = 200
            let apikeyIndexEnd = configHtml.index(apikeyInputRange.upperBound, offsetBy: substringLength)
            
            if configHtml.endIndex > apikeyIndexEnd {
                let apiKeyRange = apikeyInputRange.upperBound..<apikeyIndexEnd
                let usefullPart = configHtml.substring(with: apiKeyRange)
                
                return usefullPart.componentsMatchingRegex("[a-zA-Z0-9]{32}").first
            }
        }
        
        return nil
    }
    
}
