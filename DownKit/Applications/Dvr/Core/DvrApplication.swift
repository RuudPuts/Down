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
    case sickgear = "Sickgear"
}

public enum DvrApplicationCall {
    case showList
    case showDetails(DvrShow)
    case searchShows(String)
    case addShow(DvrShow, DvrEpisodeStatus)
    case fetchBanner(DvrShow)
    case fetchPoster(DvrShow)
    case deleteShow(DvrShow)
    case setSeasonStatus(DvrSeason, DvrEpisodeStatus)
    case setEpisodeStatus(DvrEpisode, DvrEpisodeStatus)
    case fetchEpisodeDetails(DvrEpisode)
}

extension DvrApplicationCall: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .showList:
            hasher.combine("0")
        case .showDetails(let show):
            hasher.combine("1\(show.hashValue)")
        case .searchShows(let query):
            hasher.combine("2\(query.hashValue)")
        case .addShow:
            hasher.combine("3")
        case .fetchBanner(let show):
            hasher.combine("4\(show)")
        case .fetchPoster(let show):
            hasher.combine("5\(show)")
        case .deleteShow(let show):
            hasher.combine("6\(show)")
        case .setSeasonStatus(let season, let status):
            hasher.combine("7\(season.hashValue)\(status.hashValue)")
        case .setEpisodeStatus(let episode, let status):
            hasher.combine("8\(episode.hashValue)\(status.hashValue)")
        case .fetchEpisodeDetails(let episode):
            hasher.combine("9\(episode.hashValue)")
        }
    }
    
    public static func == (lhs: DvrApplicationCall, rhs: DvrApplicationCall) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
