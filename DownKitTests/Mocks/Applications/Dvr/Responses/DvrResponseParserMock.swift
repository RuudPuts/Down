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
        var parseShow: DvrShow?
        var parseShows: [DvrShow]?
    }
    
    struct Captures {
        var parseShow: ParseShow?
        var parseShows: ParseShow?
        
        struct ParseShow {
            let storage: DataStoring
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DvrResponseParser
    
    func parseShows(from storage: DataStoring) -> [DvrShow] {
        captures.parseShows = Captures.ParseShow(storage: storage)
        return stubs.parseShows ?? []
    }
    
    func parseShowDetails(from storage: DataStoring) -> DvrShow {
        captures.parseShow = Captures.ParseShow(storage: storage)
        return stubs.parseShow ?? DvrShow(identifier: "0", name: "", quality: "")
    }
}
