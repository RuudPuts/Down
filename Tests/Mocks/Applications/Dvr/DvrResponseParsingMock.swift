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
        var parseShows: [DvrShow]?
        var parseShowDetails: DvrShow?
        var parseSearchShows: [DvrShow]?
        var parseAddShow = false
    }
    
    struct Captures {
        var parseShows: Parse?
        var parseShowDetails: Parse?
        var parseSearchShows: Parse?
        var parseAddShow: Parse?
        
        struct Parse {
            let response: Response
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
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
}
