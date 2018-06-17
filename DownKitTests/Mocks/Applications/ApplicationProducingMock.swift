//
//  ApplicationProducingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

final class ApplicationProducingMock: ApplicationProducing {
    struct Stubs {
        var makeDvr = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
    }
    
    struct Captures {
        var makeDvr: MakeDvr?
        
        struct MakeDvr {
            let type: DvrApplicationType
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // ApiApplication
    
    func makeDvr(type: DvrApplicationType) -> DvrApplication {
        captures.makeDvr = Captures.MakeDvr(type: type)
        return stubs.makeDvr
    }
}
