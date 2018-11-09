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
        var parseMovies: [DmrMovie]?

        var parseLogin = LoginResult.failed
        var parseApiKey: String?
    }
    
    struct Captures {
        var parseMovies: Parse?

        var parseLogin: Parse?
        var parseApiKey: Parse?
        
        struct Parse {
            let response: Response
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DmrResponseParsing
    
    func parseMovies(from response: Response) -> [DmrMovie] {
        captures.parseMovies = Captures.Parse(response: response)
        return stubs.parseMovies ?? []
    }

    // ApiApplicationResponseParsing

    func parseLoggedIn(from response: Response) throws -> LoginResult {
        captures.parseLogin = Captures.Parse(response: response)
        return stubs.parseLogin
    }

    func parseApiKey(from response: Response) throws -> String? {
        captures.parseApiKey = Captures.Parse(response: response)
        return stubs.parseApiKey
    }
}
