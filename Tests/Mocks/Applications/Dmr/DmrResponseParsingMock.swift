//
//  DmrResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Result

class DmrResponseParsingMock: DmrResponseParsing {
    struct Stubs {
        var application: ApiApplication!

        var parseMovies: [DmrMovie]?

        var parseLogin = LoginResult.failed
        var parseApiKey: String?
    }
    
    struct Captures {
        var `init`: Init?

        var parseMovies: Parse?

        var parseLogin: Parse?
        var parseApiKey: Parse?

        struct Init {
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
        captures.init = Captures.Init(application: application)

        stubs.application = application
    }

    convenience init() {
        self.init(application: ApiApplicationMock())
    }
    
    // DmrResponseParsing
    
    func parseMovies(from response: Response) -> Result<[DmrMovie], DownKitError> {
        captures.parseMovies = Captures.Parse(response: response)
        return .success(stubs.parseMovies ?? [])
    }

    // ApiApplicationResponseParsing

    func parseLoggedIn(from response: Response) -> Result<LoginResult, DownKitError> {
        captures.parseLogin = Captures.Parse(response: response)
        return .success(stubs.parseLogin)
    }

    func parseApiKey(from response: Response) -> Result<String?, DownKitError> {
        captures.parseApiKey = Captures.Parse(response: response)
        return .success(stubs.parseApiKey)
    }
}
