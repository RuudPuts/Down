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
}

public class ApplicationAdditionsFactory: ApplicationAdditionsProducing {
    public init() {}

    public func makeApiApplicationRequestBuilder(for application: ApiApplication) -> ApiApplicationRequestBuilding {
        switch application.type {
        case .download:
            let downloadApplication = (application as! DownloadApplication)
            switch(downloadApplication.downloadType) {
            case .sabnzbd: return SabNZBdRequestBuilder(application: downloadApplication)
            }
        case .dvr:
            let dvrApplication = (application as! DvrApplication)
            switch(dvrApplication.dvrType) {
            case .sickbeard: return SickbeardRequestBuilder(application: dvrApplication)
            }
        }
    }

    public func makeApiApplicationResponseParser(for application: ApiApplication) -> ApiApplicationResponseParsing {
        switch application.type {
        case .download:
            let downloadApplication = (application as! DownloadApplication)
            switch(downloadApplication.downloadType) {
            case .sabnzbd: return SabNZBdResponseParser()
            }
        case .dvr:
            let dvrApplication = (application as! DvrApplication)
            switch(dvrApplication.dvrType) {
            case .sickbeard: return SickbeardResponseParser()
            }
        }
    }
    
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
