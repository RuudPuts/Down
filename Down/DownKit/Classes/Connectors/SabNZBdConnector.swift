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
    
    public init() { }

    public func validateHost(_ url: URL, completion:  @escaping(_ hostValid: Bool, _ apiKey: String?) -> (Void)) {
        guard url.absoluteString.length > 0 else {
            completion(false, nil)
            return
        }
        
        let fixedUrl = url.prefixScheme().absoluteString
        SabNZBdRequest.requestString(fixedUrl, succes: { json, headers in
            // Host is valid
            self.host = fixedUrl
            
            // We got the host, lets fetch the api key
            self.fetchApiKey {
                completion(true, $0)
            }
        }, error: { error in
            Log.e("[SabNZBdConnector] Error while fetching host: \(error.localizedDescription)")
            
            self.host = nil
            self.apiKey = nil
            completion(false, self.apiKey)
        })
    }
    
    public func fetchApiKey(username: String = "", password: String = "", completion: @escaping (String?) -> (Void)) {
        guard let sabNZBdHost = host else {
            Log.w("[SabNZBdConnector] Please set host before fetching the api key")
            completion(nil)
            return
        }
        
        let loginUrl = sabNZBdHost + "/sabnzbd/login/"
        let configUrl = sabNZBdHost + "/config/general/"
        let credentials = Credentials(username: username, password: password)
        SabNZBdRequest.requestString(loginUrl, method: .post, credentials: credentials, succes: { loginResponse, headers in
            self.apiKey = nil
            
            guard self.checkLoginSuccesfull(loginResponse) else {
                Log.e("[SabNZBdConnector] Login failed")
                completion(nil)
                return
            }
            
            SabNZBdRequest.requestString(configUrl, succes: { configResponse, headers in
                self.apiKey = self.extractApiKey(configResponse)
                completion(self.apiKey)
            }, error: { error in
                Log.e("[SabNZBdConnector] Error while fetching API key: \(error.localizedDescription)")
                completion(self.apiKey)
            })
        }, error: { error in
            Log.e("[SabNZBdConnector] Error while logging in: \(error.localizedDescription)")
            completion(nil)
        })
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
                let apiKeyRange = apikeyInputRange.upperBound ..< apikeyIndexEnd
                let usefullPart = configHtml.substring(with: apiKeyRange)
                
                return usefullPart.componentsMatchingRegex("[a-zA-Z0-9]{32}").first
            }
        }
        
        return nil
    }
    
}
