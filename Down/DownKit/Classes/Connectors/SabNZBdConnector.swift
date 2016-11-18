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
    let requestManager: SessionManager
    
    public init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 3
        sessionConfiguration.timeoutIntervalForResource = 3
        
        requestManager = SessionManager(configuration: sessionConfiguration)
    }

    open func validateHost(_ url: URL, completion:  @escaping(_ hostValid: Bool, _ apiKey: String?) -> (Void)) {
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
        let authenticateHeaderValid = authenticateHeader?.range(of: "SABnzbd") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    
    open func fetchApiKey(username: String = "", password: String = "", completion: @escaping (String?) -> (Void)) {
        if let sabNZBdHost = host {
            let loginUrl = sabNZBdHost + "/sabnzbd/login/"
            let configUrl = sabNZBdHost + "/config/general/"
            let credentials = ["username": username, "password": password]
            
            requestManager.request(loginUrl, method: .post, parameters: credentials).responseString { loginHandler in
                self.apiKey = nil
                
                if loginHandler.result.isSuccess, let loginHtml = loginHandler.result.value, self.checkLoginSuccesfull(loginHtml) {
                    self.requestManager.request(configUrl).responseString { configHandler in
                        if configHandler.result.isSuccess, let configHtml = configHandler.result.value {
                            self.apiKey = self.extractApiKey(configHtml)
                        }
                        
                        completion(self.apiKey)
                    }
                }
                else {
                    completion(self.apiKey)
                }
            }
        }
        else {
            NSLog("SabNZBdConnector - Please set host before fetching the api key")
            completion(nil)
        }
    }
    
    func checkLoginSuccesfull(_ loginHtml: String) -> Bool {
        return loginHtml.range(of: "<form class=\"form-signin\" action=\"./\" method=\"post\">") == nil
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
