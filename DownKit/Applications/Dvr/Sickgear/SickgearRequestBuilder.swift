//
//  SickbeardRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SickgearRequestBuilder: SickbeardRequestBuilder {
    let authCookieKey = "_xsrf"
    let authCookieValue = "sickgear"

    override func specification(for apiCall: ApiApplicationCall, credentials: UsernamePassword? = nil) -> RequestSpecification? {
        switch apiCall {
        case .login: return RequestSpecification(
            host: application.host,
            path: "login",
            method: .post,
            headers: ["Cookie": "\(authCookieKey)=\(authCookieValue)"],
            authenticationMethod: .form,
            formAuthenticationData: makeAuthenticationData(with: credentials))
        default:
            return super.specification(for: apiCall, credentials: credentials)
        }
    }

    private func makeAuthenticationData(with credentials: UsernamePassword?) -> FormAuthenticationData? {
        guard var authData = makeDefaultFormAuthenticationData(with: credentials) else {
            return nil
        }

        authData[authCookieKey] = authCookieValue

        return authData
    }
}
