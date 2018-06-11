//
//  SickbeardRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import SwiftyJSON

public class SabNZBdRequest: DownRequest {
    
    public class func ping(_ completion: @escaping ((_ reachable: Bool) -> Void)) {
        let group = DispatchGroup()
        group.enter()
        
        SabNZBdRequest.urls().forEach { (url) in
            if let url = URL(string: url) {
                group.enter()
                SabNZBdConnector().validateHost(url, completion: { reachable, _ in
                    if reachable {
                        completion(true)
                    }
                    group.leave()
                })
            }
        }
        
        /* Default callback */
        group.notify(queue: .global()) {
            completion(false)
        }
        group.leave()
    }
    
    public class func delete(item: SABItem, succes: @escaping ((String, [AnyHashable: Any]) -> Void), error: @escaping (() -> Void)) {
        let mode = (item is SABHistoryItem) ? "history" : "queue"
        let urls = SabNZBdRequest.urls(suffix: "/api?mode=\(mode)&name=delete&value=\(item.identifier!)&apikey=\(Preferences.sabNZBdApiKey)")
        SabNZBdRequest.requestString(urls, succes: succes, error: error)
    }
    
    public class func requestHistory(start: Int = 0, limit: Int = 20, succes: @escaping ((JSON, [AnyHashable: Any]) -> Void), error: @escaping (() -> Void)) {
        let urls = SabNZBdRequest.urls(suffix: "/api?mode=history&output=json&start=\(start)&limit=\(limit)&apikey=\(Preferences.sabNZBdApiKey)")
        SabNZBdRequest.requestJson(urls, succes: succes, error: error)
    }
    
    public class func requestQueue(succes: @escaping ((JSON, [AnyHashable: Any]) -> Void), error: @escaping (() -> Void)) {
        let urls = SabNZBdRequest.urls(suffix: "/api?mode=queue&output=json&apikey=\(Preferences.sabNZBdApiKey)")
        SabNZBdRequest.requestJson(urls, succes: succes, error: error)
    }
    
    private class func urls(suffix: String? = nil) -> [String] {
        var urls = [String]()
        if let sabNZBdLocalHost = Preferences.sabNZBdHost {
            urls += ["\(sabNZBdLocalHost)\(suffix ?? "")"]
        }
        if let sabNZBdExternalHost = Preferences.sabNZBdExternalHost {
            urls += ["\(sabNZBdExternalHost)\(suffix ?? "")"]
        }
        return urls
    }
    
    override internal class func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        let serverHeader = headers["Server"] as? String
        let serverHeaderValid = serverHeader?.hasPrefix("CherryPy") ?? false
        
        let authenticateHeader = headers["Www-Authenticate"] as? String
        let authenticateHeaderValid = authenticateHeader?.range(of: "SABnzbd") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    
    override internal class func validateJson(_ json: JSON) -> (Bool, String?) {
        let error = json["error"]
        
        return (error == JSON.null, error.string)
    }
}
