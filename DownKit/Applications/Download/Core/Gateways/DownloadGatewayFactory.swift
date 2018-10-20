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

public class DownloadGatewayFactory: DownloadGatewayProducing {
    var additionsFactory: ApplicationAdditionsProducing
    
    public init(additionsFactory: ApplicationAdditionsProducing = ApplicationAdditionsFactory()) {
        self.additionsFactory = additionsFactory
    }
    
    public func makeQueueGateway(for application: DownloadApplication) -> DownloadQueueGateway {
        return DownloadQueueGateway(builder: additionsFactory.makeDownloadRequestBuilder(for: application),
                                    parser: additionsFactory.makeDownloadResponseParser(for: application))
    }
    
    public func makeHistoryGateway(for application: DownloadApplication) -> DownloadHistoryGateway {
        return DownloadHistoryGateway(builder: additionsFactory.makeDownloadRequestBuilder(for: application),
                                      parser: additionsFactory.makeDownloadResponseParser(for: application))
    }

    public func makeDeleteItemGateway(for application: DownloadApplication, item: DownloadItem) -> DownloadDeleteItemGateway {
        return DownloadDeleteItemGateway(builder: additionsFactory.makeDownloadRequestBuilder(for: application),
                                         parser: additionsFactory.makeDownloadResponseParser(for: application),
                                         item: item)
    }
}
