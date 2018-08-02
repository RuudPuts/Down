//
//  DvrApplication.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class DvrApplication: ApiApplication {
    public var name = "DvrApplication"
    public var type = ApiApplicationType.dvr
    public var dvrType: DvrApplicationType
    
    public var host: String
    public var apiKey: String
    
    public init(type: DvrApplicationType, host: String, apiKey: String) {
        self.dvrType = type
        self.host = host
        self.apiKey = apiKey
    }

    public func copy() -> Any {
        return DvrApplication(type: dvrType, host: host, apiKey: apiKey)
    }
}

public enum DvrApplicationType: String {
    case sickbeard = "Sickbeard"
}

public enum DvrApplicationCall {
    case showList
    case showDetails(DvrShow)
    case searchShows(String)
    case addShow(DvrShow, DvrEpisode.Status)
}

extension DvrApplicationCall: Hashable {
    public var hashValue: Int {
        switch self {
        case .showList:
            return 0
        case .showDetails(let show):
            return Int("1\(show.name.hashValue)") ?? 1
        case .searchShows(let query):
            return Int("2\(query.hashValue)") ?? 2
        case .addShow:
            return 3
        }
    }
    
    public static func == (lhs: DvrApplicationCall, rhs: DvrApplicationCall) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
