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

/*
 < HTTP/1.1 302 Found
 < Content-Length: 0
 < X-Robots-Tag: noindex, nofollow, noarchive, nocache, noodp, noydir, noimageindex, nosnippet
 < Vary: Accept-Encoding
 < Server: TornadoServer/5.1.1
 < Location: /login/?next=%2F
 < Cache-Control: no-store, no-cache, must-revalidate, max-age=0
 < Date: Fri, 30 Nov 2018 21:04:48 GMT
 < X-Frame-Options: SAMEORIGIN
 < Content-Type: text/html; charset=UTF-8
 */

private extension ApiApplication {
    var sessionCookie: HTTPCookie? {
        guard let hostUrl = URL.from(host: host) else {
            return nil
        }

        return CookieBag.cookie(for: hostUrl,
                                startingWith: SickgearRequestBuilder.sessionCookiePrefix)
    }
}
