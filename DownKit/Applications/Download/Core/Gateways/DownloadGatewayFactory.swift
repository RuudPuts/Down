//
//  DownloadGatewayFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownloadGatewayProducing {
    func makeQueueGateway(for application: DownloadApplication) -> DownloadQueueGateway
    func makeHistoryGateway(for application: DownloadApplication) -> DownloadHistoryGateway
    func makeDeleteItemGateway(for application: DownloadApplication, item: DownloadItem) -> DownloadDeleteItemGateway
}

public class DownloadGatewayFactory: DownloadGatewayProducing, Depending {
    public typealias Dependencies = ApplicationAdditionsFactoryDependency
    public let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeQueueGateway(for application: DownloadApplication) -> DownloadQueueGateway {
        return DownloadQueueGateway(builder: dependencies.applicationAdditionsFactory.makeDownloadRequestBuilder(for: application),
                                    parser: dependencies.applicationAdditionsFactory.makeDownloadResponseParser(for: application))
    }
    
    public func makeHistoryGateway(for application: DownloadApplication) -> DownloadHistoryGateway {
        return DownloadHistoryGateway(builder: dependencies.applicationAdditionsFactory.makeDownloadRequestBuilder(for: application),
                                      parser: dependencies.applicationAdditionsFactory.makeDownloadResponseParser(for: application))
    }

    public func makeDeleteItemGateway(for application: DownloadApplication, item: DownloadItem) -> DownloadDeleteItemGateway {
        return DownloadDeleteItemGateway(builder: dependencies.applicationAdditionsFactory.makeDownloadRequestBuilder(for: application),
                                         parser: dependencies.applicationAdditionsFactory.makeDownloadResponseParser(for: application),
                                         item: item)
    }
}
