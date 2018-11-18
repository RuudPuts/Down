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
        var parseDeleteItem = false

        var parseLogin = LoginResult.failed
        var parseApiKey: String?
    }
    
    struct Captures {
        var `init`: Init?

        var parseQueue: Parse?
        var parseHistory: Parse?
        var parseDeleteItem: Parse?

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
    }

    convenience init() {
        self.init(application: ApiApplicationMock())

        stubs.application = application
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

    func parseDeleteItem(from response: Response) throws -> Bool {
        captures.parseDeleteItem = Captures.Parse(response: response)
        return stubs.parseDeleteItem
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
