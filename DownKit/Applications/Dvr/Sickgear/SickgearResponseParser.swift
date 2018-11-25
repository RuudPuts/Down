//
//  SickgearResponseParser.swift
//  DownKit
//
//  Created by Ruud Puts on 08/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Result

class SickgearResponseParser: SickbeardResponseParser {
    override func parseLoggedIn(from response: Response) -> Result<LoginResult, DownKitError> {
        let result = super.parseLoggedIn(from: response)

        return result.map {
            if $0 == .authenticationRequired, application.sessionCookie != nil {
                return .success
            }

            return $0
        }
    }
}

private extension ApiApplication {
    var sessionCookie: HTTPCookie? {
        guard let hostUrl = URL.from(host: host) else {
            return nil
        }

        return CookieBag.cookie(for: hostUrl,
                                startingWith: SickgearRequestBuilder.sessionCookiePrefix)
    }
}
