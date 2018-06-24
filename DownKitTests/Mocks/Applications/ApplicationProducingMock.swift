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
        var makeDownload = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
        var makeDvr = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
    }
    
    struct Captures {
        var makeDownload: MakeDownload?
        var makeDvr: MakeDvr?
        
        struct MakeDownload {
            let type: DownloadApplicationType
        }
        
        struct MakeDvr {
            let type: DvrApplicationType
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // ApiApplication
    
    func makeDownload(type: DownloadApplicationType) -> DownloadApplication {
        captures.makeDownload = Captures.MakeDownload(type: type)
        return stubs.makeDownload
    }
    
    func makeDvr(type: DvrApplicationType) -> DvrApplication {
        captures.makeDvr = Captures.MakeDvr(type: type)
        return stubs.makeDvr
    }
}
