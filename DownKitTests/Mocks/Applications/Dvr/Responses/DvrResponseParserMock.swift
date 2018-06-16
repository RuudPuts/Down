//
//  DvrResponseParserMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DvrResponseParserMock: DvrResponseParser {
    struct Stubs {
        var parseShows: [DvrShow]?
        var parseShowDetails: DvrShow?
    }
    
    struct Captures {
        var parseShows: Parse?
        var parseShowDetails: Parse?
        
        struct Parse {
            let storage: DataStoring
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DvrResponseParser
    
    func parseShows(from storage: DataStoring) -> [DvrShow] {
        captures.parseShows = Captures.Parse(storage: storage)
        return stubs.parseShows ?? []
    }
    
    func parseShowDetails(from storage: DataStoring) -> DvrShow {
        captures.parseShowDetails = Captures.Parse(storage: storage)
        return stubs.parseShowDetails ?? DvrShow(identifier: "0", name: "", quality: "")
    }
}
