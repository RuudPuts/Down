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
    
    public init() { }
    
    public func validateHost(_ url: URL, completion: @escaping (Bool, String?) -> (Void)) {
        guard url.absoluteString.length > 0 else {
            completion(false, nil)
            return
        }
        
        let fixedUrl = url.prefixScheme().absoluteString
        SickbeardRequest.requestString(fixedUrl, succes: { json, headers in
            // Host is valid
            self.host = fixedUrl
            
            // We got the host, lets fetch the api key
            self.fetchApiKey {
                completion(true, $0)
            }
        }, error: { error in
            Log.e("Error while fetching host: \(error.localizedDescription)")
            
            self.host = nil
            self.apiKey = nil
            completion(false, self.apiKey)
        })
    }
    
    public func fetchApiKey(username: String = "", password: String = "", completion: @escaping (String?) -> (Void)) {
        guard let sickbeardHost = host else {
            Log.w("Please set host before fetching the api key")
            completion(nil)
            return
        }
        
        let url = sickbeardHost + "/config/general/"
        let credentials = Credentials(username: username, password: password)
        SickbeardRequest.requestString(url, credentials: credentials, succes: { configResponse, headers in
            self.apiKey = self.extractApiKey(configResponse)
            completion(self.apiKey)
        }, error: { error in
            Log.e("Error while fetching API key: \(error.localizedDescription)")
            completion(self.apiKey)
        })
    }
    
    func extractApiKey(_ configHtml: String) -> String? {
        guard let apikeyInputRange = configHtml.range(of: "id=\"api_key\"") else {
            return nil
        }

        let apiKeySubstring = configHtml[apikeyInputRange.upperBound...]

        return String(apiKeySubstring).componentsMatchingRegex("[a-zA-Z0-9]{32}").first
    }
    
}
