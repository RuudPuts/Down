//
//  ApiApplicationResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class ApiApplicationResponseParsingMock: ApiApplicationResponseParsing {
    struct Stubs {
        var parseLogin = LoginResult.failed
        var parseApiKey: String?
    }
    
    struct Captures {
        var parseLogin: Parse?
        var parseApiKey: Parse?
        
        struct Parse {
            let response: Response
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
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
