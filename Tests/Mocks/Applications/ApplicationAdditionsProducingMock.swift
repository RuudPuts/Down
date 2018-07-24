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
        var makeDownloadRequestBuilder = DownloadRequestBuildingMock(application:
            DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key"))
        var makeDownloadResponseParser = DownloadResponseParsingMock()
        
        var makeDvrRequestBuilder = DvrRequestBuildingMock(application:
                DvrApplication(type: .sickbeard, host: "host", apiKey: "key"))
        var makeDvrResponseParser = DvrResponseParsingMock()
    }
    
    struct Captures {
        var makeDownloadRequestBuilder: MakeDownload?
        var makeDownloadResponseParser: MakeDownload?
        var makeDvrRequestBuilder: MakeDvr?
        var makeDvrResponseParser: MakeDvr?
        
        struct MakeDvr {
            let application: DvrApplication
        }
        
        struct MakeDownload {
            let application: DownloadApplication
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // ApiApplication
    func makeApiApplicationRequestBuilder(for application: ApiApplication) -> ApiApplicationRequestBuilding {
        fatalError()
    }

    func makeApiApplicationResponseParser(for application: ApiApplication) -> ApiApplicationResponseParsing {
        fatalError()
    }

    func makeDownloadRequestBuilder(for application: DownloadApplication) -> DownloadRequestBuilding {
        captures.makeDownloadRequestBuilder = Captures.MakeDownload(application: application)
        return stubs.makeDownloadRequestBuilder
    }
    
    func makeDownloadResponseParser(for application: DownloadApplication) -> DownloadResponseParsing {
        captures.makeDownloadResponseParser = Captures.MakeDownload(application: application)
        return stubs.makeDownloadResponseParser
    }
    
    func makeDvrRequestBuilder(for application: DvrApplication) -> DvrRequestBuilding {
        captures.makeDvrRequestBuilder = Captures.MakeDvr(application: application)
        return stubs.makeDvrRequestBuilder
    }
    
    func makeDvrResponseParser(for application: DvrApplication) -> DvrResponseParsing {
        captures.makeDvrResponseParser = Captures.MakeDvr(application: application)
        return stubs.makeDvrResponseParser
    }
}
