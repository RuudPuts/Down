//
//  DvrResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DvrResponseParsingMock: DvrResponseParsing {
    struct Stubs {
        var application: ApiApplication!
        
        var parseShows: [DvrShow]?
        var parseShowDetails: DvrShow?
        var parseSearchShows: [DvrShow]?
        var parseAddShow = false
        var parseDeleteShow = false
        var parseSetEpisodeStatus = false
        var parseSetSeasonStatus = false

        var parseLogin = LoginResult.failed
        var parseApiKey: String?
    }
    
    struct Captures {
        var `init`: Init?

        var parseShows: Parse?
        var parseShowDetails: Parse?
        var parseSearchShows: Parse?
        var parseAddShow: Parse?
        var parseDeleteShow: Parse?
        var parseSetEpisodeStatus: Parse?
        var parseSetSeasonStatus: Parse?

        struct Init {
            let application: ApiApplication
        }

        var parseLogin: Parse?
        var parseApiKey: Parse?
        
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
    
    // DvrResponseParsing
    
    func parseShows(from response: Response) -> [DvrShow] {
        captures.parseShows = Captures.Parse(response: response)
        return stubs.parseShows ?? []
    }
    
    func parseShowDetails(from response: Response) -> DvrShow {
        captures.parseShowDetails = Captures.Parse(response: response)
        return stubs.parseShowDetails ?? DvrShow()
    }

    func parseSearchShows(from response: Response) throws -> [DvrShow] {
        captures.parseSearchShows = Captures.Parse(response: response)
        return stubs.parseSearchShows ?? []
    }

    func parseAddShow(from response: Response) throws -> Bool {
        captures.parseAddShow = Captures.Parse(response: response)
        return stubs.parseAddShow
    }

    func parseDeleteShow(from response: Response) throws -> Bool {
        captures.parseDeleteShow = Captures.Parse(response: response)
        return stubs.parseDeleteShow
    }

    func parseSetEpisodeStatus(from response: Response) throws -> Bool {
        captures.parseSetEpisodeStatus = Captures.Parse(response: response)
        return stubs.parseSetEpisodeStatus
    }

    func parseSetSeasonStatus(from response: Response) throws -> Bool {
        captures.parseSetSeasonStatus = Captures.Parse(response: response)
        return stubs.parseSetSeasonStatus
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
