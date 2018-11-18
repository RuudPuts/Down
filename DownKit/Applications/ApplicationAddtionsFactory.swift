//
//  ApplicationFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public protocol ApplicationAdditionsProducing {
    func makeApiApplicationRequestBuilder(for application: ApiApplication) -> ApiApplicationRequestBuilding
    func makeApiApplicationResponseParser(for application: ApiApplication) -> ApiApplicationResponseParsing

    func makeDownloadRequestBuilder(for application: DownloadApplication) -> DownloadRequestBuilding
    func makeDownloadResponseParser(for application: DownloadApplication) -> DownloadResponseParsing
    
    func makeDvrRequestBuilder(for application: DvrApplication) -> DvrRequestBuilding
    func makeDvrResponseParser(for application: DvrApplication) -> DvrResponseParsing

    func makeDmrRequestBuilder(for application: DmrApplication) -> DmrRequestBuilding
    func makeDmrResponseParser(for application: DmrApplication) -> DmrResponseParsing
}

public class ApplicationAdditionsFactory: ApplicationAdditionsProducing {
    public init() {}

    public func makeApiApplicationRequestBuilder(for application: ApiApplication) -> ApiApplicationRequestBuilding {
        switch application.type {
        case .download: return makeDownloadRequestBuilder(for: application as! DownloadApplication)
        case .dvr: return makeDvrRequestBuilder(for: application as! DvrApplication)
        case .dmr: return makeDmrRequestBuilder(for: application as! DmrApplication)
        }
    }

    public func makeApiApplicationResponseParser(for application: ApiApplication) -> ApiApplicationResponseParsing {
        switch application.type {
        case .download: return makeDownloadResponseParser(for: application as! DownloadApplication)
        case .dvr: return makeDvrResponseParser(for: application as! DvrApplication)
        case .dmr: return makeDmrResponseParser(for: application as! DmrApplication)
        }
    }
    
    public func makeDownloadRequestBuilder(for application: DownloadApplication) -> DownloadRequestBuilding {
        switch application.downloadType {
        case .sabnzbd: return SabNZBdRequestBuilder(application: application)
        }
    }
    
    public func makeDownloadResponseParser(for application: DownloadApplication) -> DownloadResponseParsing {
        switch application.downloadType {
        case .sabnzbd: return SabNZBdResponseParser(application: application)
        }
    }
    
    public func makeDvrRequestBuilder(for application: DvrApplication) -> DvrRequestBuilding {
        switch application.dvrType {
        case .sickbeard: return SickbeardRequestBuilder(application: application)
        case .sickgear: return SickgearRequestBuilder(application: application)
        }
    }
    
    public func makeDvrResponseParser(for application: DvrApplication) -> DvrResponseParsing {
        switch application.dvrType {
        case .sickbeard: return SickbeardResponseParser(application: application)
        case .sickgear: return SickgearResponseParser(application: application)
        }
    }

    public func makeDmrRequestBuilder(for application: DmrApplication) -> DmrRequestBuilding {
        switch application.dmrType {
        case .couchpotato: return CouchPotatoRequestBuilder(application: application)
        }
    }

    public func makeDmrResponseParser(for application: DmrApplication) -> DmrResponseParsing {
        switch application.dmrType {
        case .couchpotato: return CouchPotatoResponseParser(application: application)
        }
    }
}
