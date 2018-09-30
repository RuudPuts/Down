//
//  CouchPotatoRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class CouchPotatoRequestBuilder: DmrRequestBuilding {
    var application: ApiApplication

    lazy var defaultParameters = ["apikey": application.apiKey]
    lazy var defaultPath = "api/{apikey}/"
    
    required init(application: ApiApplication) {
        self.application = application
    }

    func specification(for apiCall: DmrApplicationCall) -> RequestSpecification? {
        switch apiCall {
        case .movieList: return RequestSpecification(
            host: application.host,
            path: defaultPath + "movie.list",
            parameters: defaultParameters
        )
        }
    }
}

extension CouchPotatoRequestBuilder: ApiApplicationRequestBuilding {
    func specification(for apiCall: ApiApplicationCall, credentials: UsernamePassword? = nil) -> RequestSpecification? {
        switch apiCall {
        case .login: return RequestSpecification(
            host: application.host,
            authenticationMethod: .form,
            formAuthenticationData: makeAuthenticationData(with: credentials)
        )
        case .apiKey: return RequestSpecification(
            host: application.host,
            path: "getkey/?u={username}&p={password}",
            parameters: [
                "username": credentials?.username ?? "",
                "password": credentials?.password ?? ""
            ]
        )
        }
    }

    private func makeAuthenticationData(with credentials: UsernamePassword?) -> FormAuthenticationData? {
        guard let credentials = credentials else {
            return nil
        }

        return FormAuthenticationData(
            fieldName: (username: "username", password: "password"),
            fieldValue: credentials
        )
    }
}
