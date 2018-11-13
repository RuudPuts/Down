//
//  SickgearResponseParser.swift
//  DownKit
//
//  Created by Ruud Puts on 08/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SickgearResponseParser: SickbeardResponseParser {
    override func parseLoggedIn(from response: Response) throws -> LoginResult {
        let result = try super.parseLoggedIn(from: response)

        if result == .authenticationRequired, response.sessionCookie != nil {
            return .success
        }

        return result
    }
}

private extension Response {
    var sessionCookie: HTTPCookie? {
        return CookieBag.cookie(for: request.url,
                                startingWith: SickgearRequestBuilder.sessionCookiePrefix)
    }
}
