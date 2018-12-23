//
//  DownloadResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DownloadResponseParsingMock: DownloadResponseParsing {
    struct Stubs {
        var application: ApiApplication!

        var parseQueue = DownloadQueue()
        var parseHistory: [DownloadItem]?
        var parseSuccess = false

        var validateServerHeader = false
        var parseLogin = LoginResult.failed
        var parseApiKey: String?
    }
    
    struct Captures {
        var `init`: Init?

        var parseQueue: Parse?
        var parseHistory: Parse?
        var parseSuccess: Parse?

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
    
    // DownloadResponseParsing
    
    func parseQueue(from response: Response) -> DownloadQueue {
        captures.parseQueue = Captures.Parse(response: response)
        return stubs.parseQueue
    }
    
    func parseHistory(from response: Response) -> [DownloadItem] {
        captures.parseHistory = Captures.Parse(response: response)
        return stubs.parseHistory ?? []
    }

    func parseSuccess(from response: Response) throws -> Bool {
        captures.parseSuccess = Captures.Parse(response: response)
        return stubs.parseSuccess
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
