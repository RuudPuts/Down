//
//  CouchPotatoRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftHash

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
            path: "login/?next=%2F",
            method: .post,
            authenticationMethod: .form,
            formAuthenticationData: makeDefaultFormAuthenticationData(with: credentials)
        )
        case .apiKey:
            let username = credentials?.username ?? ""
            let password = credentials?.password ?? ""

            return RequestSpecification(
                host: application.host,
                path: "getkey/?u={username}&p={password}",
                parameters: [
                    "username": username.isEmpty ? username : MD5(username).lowercased(),
                    "password": password.isEmpty ? password : MD5(password).lowercased(),
                ]
            )
        }
    }
}
