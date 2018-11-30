//
//  DvrResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Result

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

        var validateServerHeader = false
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
    
    func parseShows(from response: Response) -> Result<[DvrShow], DownKitError> {
        captures.parseShows = Captures.Parse(response: response)
        return .success(stubs.parseShows ?? [])
    }
    
    func parseShowDetails(from response: Response) -> Result<DvrShow, DownKitError> {
        captures.parseShowDetails = Captures.Parse(response: response)
        return .success(stubs.parseShowDetails ?? DvrShow())
    }

    func parseSearchShows(from response: Response) -> Result<[DvrShow], DownKitError> {
        captures.parseSearchShows = Captures.Parse(response: response)
        return .success(stubs.parseSearchShows ?? [])
    }

    func parseAddShow(from response: Response) -> Result<Bool, DownKitError> {
        captures.parseAddShow = Captures.Parse(response: response)
        return .success(stubs.parseAddShow)
    }

    func parseDeleteShow(from response: Response) -> Result<Bool, DownKitError> {
        captures.parseDeleteShow = Captures.Parse(response: response)
        return .success(stubs.parseDeleteShow)
    }

    func parseSetEpisodeStatus(from response: Response) -> Result<Bool, DownKitError> {
        captures.parseSetEpisodeStatus = Captures.Parse(response: response)
        return .success(stubs.parseSetEpisodeStatus)
    }

    func parseSetSeasonStatus(from response: Response) -> Result<Bool, DownKitError> {
        captures.parseSetSeasonStatus = Captures.Parse(response: response)
        return .success(stubs.parseSetSeasonStatus)
    }

    // ApiApplicationResponseParsing

    func validateServerHeader(in response: Response) -> Bool {
        return stubs.validateServerHeader
    }

    func parseLoggedIn(from response: Response) -> Result<LoginResult, DownKitError> {
        captures.parseLogin = Captures.Parse(response: response)
        return .success(stubs.parseLogin)
    }

    func parseApiKey(from response: Response) -> Result<String?, DownKitError> {
        captures.parseApiKey = Captures.Parse(response: response)
        return .success(stubs.parseApiKey)
    }
}
