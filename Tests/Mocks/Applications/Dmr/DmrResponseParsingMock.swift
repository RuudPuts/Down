//
//  DmrResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DmrResponseParsingMock: DmrResponseParsing {
    struct Stubs {
        var application: ApiApplication!

        var parseMovies: [DmrMovie]?

        var validateServerHeader = false
        var parseLogin = LoginResult.failed
        var parseApiKey: String?
    }
    
    struct Captures {
        var `default`: Default?

        var parseMovies: Parse?

        var parseLogin: Parse?
        var parseApiKey: Parse?

        struct Default {
            let application: ApiApplication
        }
        
        struct Parse {
            let response: Response
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()

    var application: ApiApplication {
        return stubs.application
    }

    required init(application: ApiApplication) {
        captures.default = Captures.Default(application: application)

        stubs.application = application
    }

    convenience init() {
        self.init(application: ApiApplicationMock())
    }
    
    // DmrResponseParsing
    
    func parseMovies(from response: Response) -> [DmrMovie] {
        captures.parseMovies = Captures.Parse(response: response)
        return stubs.parseMovies ?? []
    }

    // ApiApplicationResponseParsing

    func validateServerHeader(in response: Response) -> Bool {
        return stubs.validateServerHeader
    }

    func parseLoggedIn(from response: Response) throws -> LoginResult {
        captures.parseLogin = Captures.Parse(response: response)
        return stubs.parseLogin
    }

    func parseApiKey(from response: Response) throws -> String? {
        captures.parseApiKey = Captures.Parse(response: response)
        return stubs.parseApiKey
    }
}
