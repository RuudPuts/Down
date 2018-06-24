//
//  ApplicationFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public protocol ApplicationAdditionsProducing {
    func makeDownloadRequestBuilder(for application: DownloadApplication) -> DownloadRequestBuilding
    func makeDownloadResponseParser(for application: DownloadApplication) -> DownloadResponseParsing
    
    func makeDvrRequestBuilder(for application: DvrApplication) -> DvrRequestBuilding
    func makeDvrResponseParser(for application: DvrApplication) -> DvrResponseParsing
}

public class ApplicationAdditionsFactory: ApplicationAdditionsProducing {
    public init() {}
    
    public func makeDownloadRequestBuilder(for application: DownloadApplication) -> DownloadRequestBuilding {
        switch application.downloadType {
        case .sabnzbd: return SabNZBdRequestBuilder(application: application)
        }
    }
    
    public func makeDownloadResponseParser(for application: DownloadApplication) -> DownloadResponseParsing {
        switch application.downloadType {
        case .sabnzbd: return SabNZBdResponseParser()
        }
    }
    
    public func makeDvrRequestBuilder(for application: DvrApplication) -> DvrRequestBuilding {
        switch application.dvrType {
        case .sickbeard: return SickbeardRequestBuilder(application: application)
        }
    }
    
    public func makeDvrResponseParser(for application: DvrApplication) -> DvrResponseParsing {
        switch application.dvrType {
        case .sickbeard: return SickbeardResponseParser()
        }
    }
}
