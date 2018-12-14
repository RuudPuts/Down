//
//  SickgearResponseParser.swift
//  DownKit
//
//  Created by Ruud Puts on 08/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SickgearResponseParser: SickbeardResponseParser {
    override func validateServerHeader(in response: Response) -> Bool {
        return response.headers?["Server"]?.matches("TornadoServer\\/.*?") ?? false
    }

    override func parseLoggedIn(from response: Response) throws -> LoginResult {
        let result = try super.parseLoggedIn(from: response)

        if result == .authenticationRequired, application.sessionCookie != nil {
            return .success
        }

        return result
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
