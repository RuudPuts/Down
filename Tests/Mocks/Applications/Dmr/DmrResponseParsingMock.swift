//
//  DmrResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DmrResponseParsingMock: DmrResponseParsing {
    struct Stubs {
        var parseMovies: [DmrMovie]?
    }
    
    struct Captures {
        var parseMovies: Parse?
        
        struct Parse {
            let response: Response
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DmrResponseParsing
    
    func parseMovies(from response: Response) -> [DmrMovie] {
        captures.parseMovies = Captures.Parse(response: response)
        return stubs.parseMovies ?? []
    }
}
