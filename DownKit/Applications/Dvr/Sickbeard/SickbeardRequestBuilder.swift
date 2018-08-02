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
    
    required init(application: ApiApplication) {
        self.application = application
    }

    func specification(for apiCall: DvrApplicationCall) -> RequestSpecification? {
        switch apiCall {
        case .showList: return RequestSpecification(
            host: application.host,
            path: "api/{apikey}?cmd=shows",
            parameters: defaultParameters
        )
        case .showDetails(let show): return RequestSpecification(
            host: application.host,
            path: "api/{apikey}?cmd=show.seasons%7Cshow&tvdbid={id}",
            parameters: defaultParameters.merging(["id": show.identifier], uniquingKeysWith: { $1 })
        )
        case .searchShows(let query): return RequestSpecification(
            host: application.host,
            path: "api/{apikey}?cmd=searchtvdb&name={query}",
            parameters: defaultParameters.merging(["query": query], uniquingKeysWith: { $1 })
        )
        case .addShow(let show, let status): return RequestSpecification(
            host: application.host,
            path: "api/{apikey}?cmd=show.addnew&tvdbid={id}&status={status}",
            parameters: defaultParameters.merging([
                    "id": show.identifier,
                    "status": status.rawValue
                ], uniquingKeysWith: { $1 })
        )
        }
    }
}

extension SickbeardRequestBuilder: ApiApplicationRequestBuilding {
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
