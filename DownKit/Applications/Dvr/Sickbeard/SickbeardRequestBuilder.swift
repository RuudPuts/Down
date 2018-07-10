//
//  SickbeardRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SickbeardRequestBuilder: DvrRequestBuilding {
    var application: DvrApplication
    
    required init(application: DvrApplication) {
        self.application = application
    }
    
    func path(for apiCall: DvrApplicationCall) -> String? {
        switch apiCall {
        case .showList:
            return "api/{apikey}?cmd=shows"
        case .showDetails:
            return "api/{apikey}?cmd=show.seasons%7Cshow&tvdbid={id}"
        }
    }

    func parameters(for apiCall: DvrApplicationCall) -> [String: String]? {
        switch apiCall {
        case .showList:
            return nil
        case .showDetails(let show):
            return ["id": show.identifier]
        }
    }
    
    func method(for apiCall: DvrApplicationCall) -> Request.Method {
        return .get
    }

    func basicAuthenticationData(username: String, password: String) -> BasicAuthenticationData? {
        return BasicAuthenticationData(username: username, password: password)
    }
}

extension SickbeardRequestBuilder: ApiApplicationRequestBuilding {
    var host: String {
        return application.host
    }

    func path(for apiCall: ApiApplicationCall) -> String? {
        switch apiCall {
        case .apiKey:
            return "config/general"
        default:
            return nil
        }
    }

    func authenticationMethod(for apiCall: ApiApplicationCall) -> AuthenticationMethod {
        switch apiCall {
        case .login:
            return .basic
        default:
            return .none
        }
    }
}
