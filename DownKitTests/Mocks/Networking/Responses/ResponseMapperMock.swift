//
//  ResponseMapperMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class ResponseMapperMock<Type>: ResponseMapper {
    struct Stubs {
        var mapStorage: MapStorage?
        
        struct MapStorage {
            let returnValue: ResponseType
        }
    }
    
    struct Captures {
        var `init`: Init?
        var mapStorage: MapStorage?
        
        struct Init {
            let parser: ResponseParser
        }
        
        struct MapStorage {
            let storage: DataStoring
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    convenience init() {
        self.init(parser: ResponseParserMock())
    }
    
    // ResponseMapper
    
    typealias ResponseType = Type
    var parser: ResponseParser
    
    required init(parser: ResponseParser) {
        captures.init = Captures.Init(parser: parser)
        self.parser = parser
    }
    
    func map(storage: DataStoring) -> ResponseType {
        captures.mapStorage = Captures.MapStorage(storage: storage)
        return stubs.mapStorage!.returnValue
    }
}
