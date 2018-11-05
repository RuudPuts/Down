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
    public typealias Dependencies = DatabaseDependency & DownloadGatewayFactoryDependency
    public let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeQueueInteractor(for application: DownloadApplication) -> DownloadQueueInteractor {
        let gateway = dependencies.downloadGatewayFactory.makeQueueGateway(for: application)
        
        return DownloadQueueInteractor(dependencies: dependencies, gateway: gateway)
    }
    
    public func makeHistoryInteractor(for application: DownloadApplication) -> DownloadHistoryInteractor {
        let gateway = dependencies.downloadGatewayFactory.makeHistoryGateway(for: application)
        
        return DownloadHistoryInteractor(dependencies: dependencies, gateway: gateway)
    }

    public func makeDeleteItemInteractor(for application: DownloadApplication, item: DownloadItem) -> DownloadDeleteItemInteractor {
        let gateway = dependencies.downloadGatewayFactory.makeDeleteItemGateway(for: application, item: item)

        return DownloadDeleteItemInteractor(gateway: gateway)
    }
}
