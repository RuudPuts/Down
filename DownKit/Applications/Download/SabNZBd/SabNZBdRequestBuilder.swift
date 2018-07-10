//
//  SabNZBdRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SabNZBdRequestBuilder: DownloadRequestBuilding {
    var application: DownloadApplication

    required init(application: DownloadApplication) {
        self.application = application
    }
    
    func path(for apiCall: DownloadApplicationCall) -> String? {
        return "api?mode=\(apiCall.rawValue)&output=json&apikey={apikey}"
    }
    
    func method(for apiCall: DownloadApplicationCall) -> Request.Method {
        return .get
    }

    func formAuthenticationData(username: String, password: String) -> FormAuthenticationData? {
        return FormAuthenticationData(fieldName: (username: "username", password: "password"),
                                      fieldValue: (username, password))
    }
}

extension SabNZBdRequestBuilder: ApiApplicationRequestBuilding {
    var host: String {
        return application.host
    }

    func authenticationMethod(for apiCall: ApiApplicationCall) -> AuthenticationMethod {
        switch apiCall {
        case .login:
            return .form
        default:
            return .none
        }
    }

    func path(for apiCall: ApiApplicationCall) -> String? {
        switch apiCall {
        case .login:
            return "sabnzbd/login"
        case .apiKey:
            return "config/general"
        }
    }
}
