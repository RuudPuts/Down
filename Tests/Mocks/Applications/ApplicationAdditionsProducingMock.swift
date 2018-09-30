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
        var makeApiApplicationRequestBuilder = ApiApplicationRequestBuildingMock(application:
            ApiApplicationMock())
        var makeApiApplicationResponseParser = ApiApplicationResponseParsingMock()

        var makeDownloadRequestBuilder = DownloadRequestBuildingMock(application:
            DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key"))
        var makeDownloadResponseParser = DownloadResponseParsingMock()
        
        var makeDvrRequestBuilder = DvrRequestBuildingMock(application:
                DvrApplication(type: .sickbeard, host: "host", apiKey: "key"))
        var makeDvrResponseParser = DvrResponseParsingMock()

        var makeDmrRequestBuilder = DmrRequestBuildingMock(application:
            DmrApplication(type: .couchpotato, host: "host", apiKey: "key"))
        var makeDmrResponseParser = DmrResponseParsingMock()
    }
    
    struct Captures {
        var makeApiApplicationRequestBuilder: MakeApiApplication?
        var makeApiApplicationResponseParser: MakeApiApplication?
        var makeDownloadRequestBuilder: MakeDownload?
        var makeDownloadResponseParser: MakeDownload?
        var makeDvrRequestBuilder: MakeDvr?
        var makeDvrResponseParser: MakeDvr?
        var makeDmrRequestBuilder: MakeDmr?
        var makeDmrResponseParser: MakeDmr?

        struct MakeApiApplication {
            let application: ApiApplication
        }

        struct MakeDownload {
            let application: DownloadApplication
        }

        struct MakeDvr {
            let application: DvrApplication
        }

        struct MakeDmr {
            let application: DmrApplication
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // ApiApplication
    func makeApiApplicationRequestBuilder(for application: ApiApplication) -> ApiApplicationRequestBuilding {
        captures.makeApiApplicationRequestBuilder = Captures.MakeApiApplication(application: application)
        return stubs.makeApiApplicationRequestBuilder
    }

    func makeApiApplicationResponseParser(for application: ApiApplication) -> ApiApplicationResponseParsing {
        captures.makeApiApplicationResponseParser = Captures.MakeApiApplication(application: application)
        return stubs.makeApiApplicationResponseParser
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

    func makeDmrRequestBuilder(for application: DmrApplication) -> DmrRequestBuilding {
        captures.makeDmrRequestBuilder = Captures.MakeDmr(application: application)
        return stubs.makeDmrRequestBuilder
    }

    func makeDmrResponseParser(for application: DmrApplication) -> DmrResponseParsing {
        captures.makeDmrResponseParser = Captures.MakeDmr(application: application)
        return stubs.makeDmrResponseParser
    }
}
