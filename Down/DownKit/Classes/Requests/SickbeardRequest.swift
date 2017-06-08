//
//  SickbeardRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

public class SickbeardRequest: DownRequest {
    
    override class func requestJson(_ url: String, method: Method = .get, credentials: Credentials? = nil, parameters: [String: Any]? = nil,
                           succes: @escaping (JSON, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        super.requestJson(url, method: method, credentials: credentials, parameters: parameters, succes: { json, headers in
            succes(json["data"], headers)
        }, error: error)
    }
    
    public class func requestShows(succes: @escaping ((JSON, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=shows")
        SickbeardRequest.requestJson(urls, succes: succes, error: error)
    }
    
    public class func requestShow(_ show: Int, succes: @escaping ((JSON, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=show&tvdbid=\(show)")
        SickbeardRequest.requestJson(urls, succes: succes, error: error)
    }
    
    public class func requestSeasons(show: Int, succes: @escaping ((JSON, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=show.seasons&tvdbid=\(show)")
        SickbeardRequest.requestJson(urls, succes: succes, error: error)
    }
    
    public class func requestEpisode(show: Int, season: Int, episode: Int, succes: @escaping ((JSON, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=episode&tvdbid=\(show)&season=\(season)&episode=\(episode)")
        SickbeardRequest.requestJson(urls, succes: succes, error: error)
    }
    
    public class func deleteShow(_ show: Int, succes: @escaping ((JSON, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=show.delete&tvdbid=\(show)")
        SickbeardRequest.requestJson(urls, succes: succes, error: error)
    }
    
    public class func addShow(_ show: Int, state: SickbeardEpisode.Status, succes: @escaping ((JSON, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=show.addnew&tvdbid=\(show)&status=\(state.rawValue.lowercased())")
        SickbeardRequest.requestJson(urls, succes: succes, error: error)
    }
    
    public class func setState(show: Int, season: Int? = nil, episode: Int? = nil, state: SickbeardEpisode.Status, succes: ((JSON, [AnyHashable : Any]) -> ())? = nil, error: (() -> ())? = nil) {
        
        var cmd = "?cmd=episode.setstatus&status=" + state.rawValue.lowercased() + "&tvdbid=\(show)&force=1"
        if let season = season {
            cmd += "&season=\(season)"
            if let episode = episode {
                
                cmd += "&episode=\(episode)"
            }
        }
        
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + cmd)
        SickbeardRequest.requestJson(urls, succes: { (json, headers) in
            succes?(json, headers)
        }, error: {
            error?()
        })
    }
    
    public class func requestBanner(show: Int, succes: @escaping ((Data, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=show.getbanner&tvdbid=\(show)")
        SickbeardRequest.requestData(urls, succes: succes, error: error)
    }
    
    public class func requestPoster(show: Int, succes: @escaping ((Data, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=show.getposter&tvdbid=\(show)")
        SickbeardRequest.requestData(urls, succes: succes, error: error)
    }
    
    public class func searchTvdb(query: String, succes: @escaping ((JSON, [AnyHashable : Any]) -> ()), error: @escaping (() -> ())) {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        let urls = SickbeardRequest.urls(suffix: "/api/" + Preferences.sickbeardApiKey + "?cmd=sb.searchtvdb&lang=en&name=" + escapedQuery)
        SickbeardRequest.requestJson(urls, succes: succes, error: error)
    }
    
    // MARK: Requests
    
    override internal class func authenticationMethod() -> AuthenticationMethod {
        return .basic
    }
    
    // MARK: Validation
    
    private class func urls(suffix: String? = nil) -> [String] {
        var urls = [String]()
        if let sickbeardLocalHost = Preferences.sickbeardHost {
            urls += ["\(sickbeardLocalHost)\(suffix ?? "")"]
        }
        if let sickbeardExternalHost = Preferences.sickbeardExternalHost {
            urls += ["\(sickbeardExternalHost)\(suffix ?? "")"]
        }
        return urls
    }
    
    override internal class func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        let serverHeader = headers["Server"] as? String
        let serverHeaderValid = serverHeader?.hasPrefix("CherryPy") ?? false || serverHeader?.hasPrefix("TornadoServer") ?? false
        
        let authenticateHeader = headers["Www-Authenticate"] as? String
        let authenticateHeaderValid = authenticateHeader?.range(of: "Sickbeard") != nil
        
        return serverHeaderValid || authenticateHeaderValid
    }
    
    override internal class func validateJson(_ json: JSON) -> (Bool, String?) {
        let (jsonValid, _) = super.validateJson(json)
        
        return (jsonValid && json["result"].string != "failure", json["message"].string)
    }
    
}
