//
//  DownloadResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Result

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

        stubs.application = application
    }

    convenience init() {
        self.init(application: ApiApplicationMock())
    }
    
    // DownloadResponseParsing
    
    func parseQueue(from response: Response) -> Result<DownloadQueue, DownKitError> {
        captures.parseQueue = Captures.Parse(response: response)
        return .success(stubs.parseQueue)
    }
    
    func parseHistory(from response: Response) -> Result<[DownloadItem], DownKitError> {
        captures.parseHistory = Captures.Parse(response: response)
        return .success(stubs.parseHistory ?? [])
    }

    func parseDeleteItem(from response: Response) -> Result<Bool, DownKitError> {
        captures.parseDeleteItem = Captures.Parse(response: response)
        return .success(stubs.parseDeleteItem)
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
