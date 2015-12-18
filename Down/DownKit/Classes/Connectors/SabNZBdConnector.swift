//
//  SabNZBdConnector.swift
//  Down
//
//  Created by Ruud Puts on 18/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

public class SabNZBdConnector: Connector {
    
    public var host: String?

    public func validateHost(host: String, completion: (Bool) -> (Void)) {
        request(.GET, host).responseString { _, urlResponse, _ in
            var hostValid = false
            
            if let response = urlResponse {
                let serverHeader = response.allHeaderFields["Server"] as! String?
                let authenticateHeader = response.allHeaderFields["Www-Authenticate"] as! String?
                if (serverHeader?.hasPrefix("CherryPy") ?? false) && authenticateHeader?.rangeOfString("SABnzbd") != nil {
                    hostValid = true
                    self.host = host
                }
            }
            
            completion(hostValid)
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
            
            request(.GET, url).responseString { _, urlResponse, reponseString in                
                if let html = reponseString.value {
                    if let apikeyInputRange = html.rangeOfString("id=\"apikey\"") {
                        // WARN: Assumption; api key is within 200 characters from the input id
                        let substringLength = 200
                        let apikeyIndexEnd = apikeyInputRange.endIndex.advancedBy(substringLength)
                        
                        if html.endIndex > apikeyIndexEnd {
                            let apiKeyRange = Range(start:apikeyInputRange.endIndex, end:apikeyIndexEnd)
                            let usefullPart = html.substringWithRange(apiKeyRange)
                            
                            if let apikey = usefullPart.componentsMatchingRegex("[a-zA-Z0-9]{32}").first {
                                NSLog("ApiKey: \(apikey)")
                            }
                        }
                    }
                }
            }
        }
        else {
            completion(nil)
        }
    }
    
}

extension String {
    func insert(string: String, atIndex index: Int) -> String {
        return  String(self.characters.prefix(index)) + string + String(self.characters.suffix(self.characters.count - index))
    }
    
    func componentsMatchingRegex(regex: String) -> [String] {
        var matches = [String]()
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let text = self as NSString
            let results = regex.matchesInString(self, options: [], range: NSMakeRange(0, text.length))
            matches = results.map { text.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
        }
        
        return matches
    }
}