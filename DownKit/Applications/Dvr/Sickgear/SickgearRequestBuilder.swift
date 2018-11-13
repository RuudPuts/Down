//
//  SickbeardRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SickgearRequestBuilder: SickbeardRequestBuilder {
    internal static let sessionCookiePrefix = "sickgear-session-"
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
                formAuthenticationData: makeAuthenticationData(with: credentials)
            )
        case .apiKey:
            guard var spec = super.specification(for: apiCall, credentials: credentials) else {
                return nil
            }

            if let url = URL.from(host: spec.host),
               let sessionCookie = CookieBag.cookie(for: url, startingWith: SickgearRequestBuilder.sessionCookiePrefix) {
                spec.headers = ["Cookie": "\(sessionCookie.name)=\(sessionCookie.value)"]
            }

            return spec
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
