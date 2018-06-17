//
//  ApplicationAdditionsProducingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

final class ApplicationAdditionsProducingMock: ApplicationAdditionsProducing {
    struct Stubs {
        var makeDvrRequestBuilder = DvrRequestBuildingMock(application:
                DvrApplication(type: .sickbeard, host: "host", apiKey: "key"))
        var makeDvrResponseParser = DvrResponseParsingMock()
    }
    
    struct Captures {
        var makeDvrRequestBuilder: MakeDvr?
        var makeDvrResponseParser: MakeDvr?
        
        struct MakeDvr {
            let application: DvrApplication
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // ApiApplication
    
    func makeDvrRequestBuilder(for application: DvrApplication) -> DvrRequestBuilding {
        captures.makeDvrRequestBuilder = Captures.MakeDvr(application: application)
        return stubs.makeDvrRequestBuilder
    }
    
    func makeDvrResponseParser(for application: DvrApplication) -> DvrResponseParsing {
        captures.makeDvrResponseParser = Captures.MakeDvr(application: application)
        return stubs.makeDvrResponseParser
    }
}
