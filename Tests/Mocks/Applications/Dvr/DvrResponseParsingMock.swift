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
        var parseEpisodeDetails: DvrEpisode?
        var parseSetEpisodeStatus = false
        var parseSetSeasonStatus = false

        var validateServerHeader = false
        var parseLogin = LoginResult.failed
        var parseApiKey: String?
    }
    
    struct Captures {
        var `default`: Default?

        var parseShows: Parse?
        var parseShowDetails: Parse?
        var parseSearchShows: Parse?
        var parseAddShow: Parse?
        var parseDeleteShow: Parse?
        var parseSetEpisodeStatus: Parse?
        var parseSetSeasonStatus: Parse?
        var parseEpisodeDetails: ParseEpisodeDetails?

        struct Default {
            let application: ApiApplication
        }

        var parseLogin: Parse?
        var parseApiKey: Parse?
        
        struct Parse {
            let response: Response
        }

        struct ParseEpisodeDetails {
            let episode: DvrEpisode
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

    func parseEpisodeDetails(for episode: DvrEpisode, from response: Response) throws -> DvrEpisode {
        captures.parseEpisodeDetails = Captures.ParseEpisodeDetails(episode: episode, response: response)
        return stubs.parseEpisodeDetails!
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
