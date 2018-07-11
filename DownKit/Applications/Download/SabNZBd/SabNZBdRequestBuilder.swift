//
//  SabNZBdRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SabNZBdRequestBuilder: DownloadRequestBuilding {
    var application: ApiApplication

    lazy var defaultParameters = ["apikey": application.apiKey]

    required init(application: ApiApplication) {
        self.application = application
    }

    func specification(for apiCall: DownloadApplicationCall) -> RequestSpecification? {
        return RequestSpecification(
            host: application.host,
            path: "api?mode=\(apiCall.rawValue)&output=json&apikey={apikey}",
            parameters: defaultParameters
        )
    }
}

extension SabNZBdRequestBuilder: ApiApplicationRequestBuilding {
    func specification(for apiCall: ApiApplicationCall, credentials: UsernamePassword? = nil) -> RequestSpecification? {
        switch apiCall {
        case .login: return RequestSpecification(
            host: application.host,
            path: "sabnzbd/login",
            authenticationMethod: .form,
            formAuthenticationData: makeAuthenticationData(with: credentials!)
        )
        case .apiKey: return RequestSpecification(
            host: application.host,
            path: "config/general"
        )}
    }

    private func makeAuthenticationData(with credentials: UsernamePassword) -> FormAuthenticationData {
        return FormAuthenticationData(
            fieldName: (username: "username", password: "password"),
            fieldValue: credentials
        )
    }
}
