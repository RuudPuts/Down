//
//  DownloadInteractorFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownloadInteractorProducing {
    func makeQueueInteractor(for application: DownloadApplication) -> DownloadQueueInteractor
    func makeHistoryInteractor(for application: DownloadApplication) -> DownloadHistoryInteractor
}

public class DownloadInteractorFactory: DownloadInteractorProducing {
    var dvrDatabase: DvrDatabase
    var gatewayFactory: DownloadGatewayProducing
    
    public init(dvrDatabase: DvrDatabase, gatewayFactory: DownloadGatewayProducing = DownloadGatewayFactory()) {
        self.gatewayFactory = gatewayFactory
        self.dvrDatabase = dvrDatabase
    }
    
    public func makeQueueInteractor(for application: DownloadApplication) -> DownloadQueueInteractor {
        let gateway = gatewayFactory.makeQueueGateway(for: application)
        
        return DownloadQueueInteractor(gateway: gateway)
    }
    
    public func makeHistoryInteractor(for application: DownloadApplication) -> DownloadHistoryInteractor {
        let gateway = gatewayFactory.makeHistoryGateway(for: application)
        
        return DownloadHistoryInteractor(gateway: gateway)
    }
}
