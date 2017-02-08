//
//  SickbeardRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

enum RequestParameter: String {
    case host
    case apikey
}

enum SickbeardRequestType {
    // Shows
    case fetchShows
    case searchShows(query: String)
    
    // Show
    case addShow(show: SickbeardShow)
    case refreshShow(show: SickbeardShow)
    case refreshSeasons(show: SickbeardShow)
    case deleteShow(show: SickbeardShow)
    
    // Season
    case setSeasonStatus(season: SickbeardSeason, status: SickbeardEpisode.Status)
    
    // Episode
    case fetchPlot(episode: SickbeardEpisode)
    case setEpisodeStatus(episode: SickbeardEpisode, status: SickbeardEpisode.Status)
    
    // Images
    case downloadBanner(show: SickbeardShow)
    case downloadPoster(show: SickbeardShow)
    
    func commandFormat() -> String {
        switch self {
        case .fetchShows: return "?cmd=shows"
        default: return ""
        }
    }
}

typealias IntArray = ([Int]) -> (Void)
enum SickbeardRequestCallback {
    case intArray(_ : IntArray)
}

class SickbeardRequest: DownRequest {
    
    static let DefaultHttpFormat = "<host>/api/<apikey>"
    
    // TODO: Find more suitable name than run
    class func run(_ request: SickbeardRequestType, _ completion: @escaping (Any) -> (Void)) {
        let url = buildUrl(forRequest: request)
        
        requestJson(url, succes: { json, _ in
            parse(request, json, completion)
        }) { error in
            completion("")
        }
    }
    
    class func buildUrl(forRequest request: SickbeardRequestType) -> String {
        let format = DefaultHttpFormat + request.commandFormat()
        let parameters: [RequestParameter: String] = [
            .host: Preferences.sickbeardHost, .apikey : Preferences.sickbeardApiKey
        ]
        
        var url = format
        parameters.forEach { key, value in
            let keyTag = String(format: "<%@>", key.rawValue)
            url = url.replacingOccurrences(of: keyTag, with: value)
        }
        
        return url
    }
    
    class func parse(_ request: SickbeardRequestType, _ json: JSON, _ completion: (Any) -> (Void)) {
        let result: Any
        let jsonData = json["data"].rawValue as! [String: AnyObject]
        
        switch request {
        case .fetchShows:
            result = Array(jsonData.keys).map { Int($0)! }
            break
        default:
            result = ""
            break
        }
        
        completion(result)
    }
    
    // MARK: Requests
    
    override internal class func authenticationMethod() -> AuthenticationMethod {
        return .basic
    }
    
    // MARK: Validation
    
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
