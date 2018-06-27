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
    
    // DvrResponseParsing
    
    func parseShows(from storage: DataStoring) -> [DvrShow] {
        captures.parseShows = Captures.Parse(storage: storage)
        return stubs.parseShows ?? []
    }
    
    func parseShowDetails(from storage: DataStoring) -> DvrShow {
        captures.parseShowDetails = Captures.Parse(storage: storage)
        return stubs.parseShowDetails ?? DvrShow(identifier: "0", name: "", quality: "")
    }
}
