//
//  SickbeardRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SickbeardRequestBuilder: DvrRequestBuilding {
    var application: ApiApplication

    lazy var defaultParameters = ["apikey": application.apiKey]
    lazy var defaultPath = "api/{apikey}?"
    
    required init(application: ApiApplication) {
        self.application = application
    }

    // swiftlint:disable:next function_body_length
    func specification(for apiCall: DvrApplicationCall) -> RequestSpecification? {
        switch apiCall {
        case .showList: return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=shows",
            parameters: defaultParameters
        )
        case .showDetails(let show): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=show.seasons%7Cshow&tvdbid={id}",
            parameters: defaultParameters.merging(["id": show.identifier], uniquingKeysWith: { $1 })
        )
        case .searchShows(let query): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=sb.searchtvdb&name={query}",
            parameters: defaultParameters.merging(["query": query], uniquingKeysWith: { $1 })
        )
        case .addShow(let show, let status): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=show.addnew&tvdbid={id}&status={status}",
            parameters: defaultParameters.merging([
                    "id": show.identifier,
                    "status": status.sickbeardValue
                ], uniquingKeysWith: { $1 })
        )
        case .fetchBanner(let show): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=show.getbanner&tvdbid={id}",
            parameters: defaultParameters.merging([
                "id": show.identifier
                ], uniquingKeysWith: { $1 })
            )
        case .fetchPoster(let show): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=show.getposter&tvdbid={id}",
            parameters: defaultParameters.merging([
                "id": show.identifier
                ], uniquingKeysWith: { $1 })
            )
        case .deleteShow(let show): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=show.delete&tvdbid={id}",
            parameters: defaultParameters.merging(["id": show.identifier], uniquingKeysWith: { $1 })
            )
        case .setSeasonStatus(let season, let status): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=episode.setstatus&tvdbid={show_id}&season={season_id}&status={status}",
            parameters: defaultParameters.merging([
                    "show_id": season.show.identifier,
                    "season_id": season.identifier,
                    "status": status.sickbeardValue
                ], uniquingKeysWith: { $1 })
            )
        case .setEpisodeStatus(let episode, let status): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=episode.setstatus&tvdbid={show_id}&season={season_id}&episode={episode_id}&status={status}",
            parameters: defaultParameters.merging([
                    "show_id": episode.show.identifier,
                    "season_id": episode.season.identifier,
                    "episode_id": episode.identifier,
                    "status": status.sickbeardValue
                ], uniquingKeysWith: { $1 })
            )
        case .fetchEpisodeDetails(let episode): return RequestSpecification(
            host: application.host,
            path: defaultPath + "cmd=episode&tvdbid={show_id}&season={season_id}&episode={episode_id}",
            parameters: defaultParameters.merging([
                "show_id": episode.show.identifier,
                "season_id": episode.season.identifier,
                "episode_id": episode.identifier
                ], uniquingKeysWith: { $1 })
            )
        }
    }
    
    func specification(for apiCall: ApiApplicationCall, credentials: UsernamePassword? = nil) -> RequestSpecification? {
        switch apiCall {
        case .login: return RequestSpecification(
            host: application.host,
            authenticationMethod: .basic,
            basicAuthenticationData: makeAuthenticationData(with: credentials)
        )
        case .apiKey: return RequestSpecification(
            host: application.host,
            path: "config/general"
        )}
    }

    private func makeAuthenticationData(with credentials: UsernamePassword?) -> BasicAuthenticationData? {
        guard let credentials = credentials else {
            return nil
        }
        return BasicAuthenticationData(credentials)
    }
}
