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
        var parseQueue = DownloadQueue()
        var parseHistory: [DownloadItem]?
    }
    
    struct Captures {
        var parseQueue: Parse?
        var parseHistory: Parse?
        
        struct Parse {
            let response: Response
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DownloadResponseParsing
    
    func parseQueue(from response: Response) -> DownloadQueue {
        captures.parseQueue = Captures.Parse(response: response)
        return stubs.parseQueue
    }
    
    func parseHistory(from response: Response) -> [DownloadItem] {
        captures.parseHistory = Captures.Parse(response: response)
        return stubs.parseHistory ?? []
    }
}
