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
    let requestManager: SessionManager
    
    public init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 2
        sessionConfiguration.timeoutIntervalForResource = 2
        
        requestManager = SessionManager(configuration: sessionConfiguration)
    }
    
    public func validateHost(_ url: URL, completion: @escaping (Bool, String?) -> (Void)) {
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
                        completion(hostValid, $0)
                    }

                    // fetchApiKey completion handler will call our completion handler
                    return
                }
            }
            
            completion(hostValid, self.apiKey)
        }
    }
    
    func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        let serverHeader = headers["Server"] as? String
        let serverHeaderValid = serverHeader?.hasPrefix("CherryPy") ?? false
        
        let authenticateHeader = headers["Www-Authenticate"] as? String
        let authenticateHeaderValid = authenticateHeader?.range(of: "Sickbeard") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    
    public func fetchApiKey(username: String = "", password: String = "", completion: @escaping (String?) -> (Void)) {
        if let sickbeardHost = host {
            let url = sickbeardHost + "/config/general/"
            
            requestManager.request(url).authenticate(user: username, password: password).responseString { handler in
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
    
    func extractApiKey(_ configHtml: String) -> String? {
        if let apikeyInputRange = configHtml.range(of: "id=\"api_key\"") {
            // WARNING: Assumption; api key is within 200 characters from the input id
            let substringLength = 200
            let apikeyIndexEnd = configHtml.index(apikeyInputRange.upperBound, offsetBy: substringLength)
            
            if configHtml.endIndex > apikeyIndexEnd {
                let apiKeyRange = apikeyInputRange.upperBound ..< apikeyIndexEnd
                let usefullPart = configHtml.substring(with: apiKeyRange)
                
                return usefullPart.componentsMatchingRegex("[a-zA-Z0-9]{32}").first
            }
        }
        
        return nil
    }
    
}
