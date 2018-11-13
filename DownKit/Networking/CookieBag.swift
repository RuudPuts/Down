//
//  CookieBag.swift
//  DownKit
//
//  Created by Ruud Puts on 13/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

typealias CookieBag = HTTPCookieStorage

extension CookieBag {
    static var instance: CookieBag? {
        return URLSession.shared.configuration.httpCookieStorage
    }

    static func cookie(for url: URL, startingWith prefix: String) -> HTTPCookie? {
        return instance?.cookies(for: url)?
            .first(where: { $0.name.starts(with: prefix) })
    }
}
