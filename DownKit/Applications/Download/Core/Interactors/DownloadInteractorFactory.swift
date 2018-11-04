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

    func makeDeleteItemInteractor(for application: DownloadApplication, item: DownloadItem) -> DownloadDeleteItemInteractor
}

public class DownloadInteractorFactory: DownloadInteractorProducing, Depending {
    public typealias Dependencies = DatabaseDependency
    public let dependencies: DatabaseDependency

    var gatewayFactory: DownloadGatewayProducing
    
    public init(dependencies: Dependencies, gatewayFactory: DownloadGatewayProducing = DownloadGatewayFactory()) {
        self.dependencies = dependencies
        self.gatewayFactory = gatewayFactory
    }
    
    public func makeQueueInteractor(for application: DownloadApplication) -> DownloadQueueInteractor {
        let gateway = gatewayFactory.makeQueueGateway(for: application)
        
        return DownloadQueueInteractor(dependencies: dependencies, gateway: gateway)
    }
    
    public func makeHistoryInteractor(for application: DownloadApplication) -> DownloadHistoryInteractor {
        let gateway = gatewayFactory.makeHistoryGateway(for: application)
        
        return DownloadHistoryInteractor(dependencies: dependencies, gateway: gateway)
    }

    public func makeDeleteItemInteractor(for application: DownloadApplication, item: DownloadItem) -> DownloadDeleteItemInteractor {
        let gateway = gatewayFactory.makeDeleteItemGateway(for: application, item: item)

        return DownloadDeleteItemInteractor(gateway: gateway)
    }
}
