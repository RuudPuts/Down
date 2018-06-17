//
//  DvrGatewayFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrGatewayProducing {
    func makeShowListGateway(for application: DvrApplication) -> ShowListGateway
    func makeShowDetailsGateway(for application: DvrApplication, show: DvrShow) -> ShowDetailsGateway
}

public class DvrGatewayFactory: DvrGatewayProducing {
    var additionsFactory: ApplicationAdditionsProducing
    
    public init(additionsFactory: ApplicationAdditionsProducing = ApplicationAdditionsFactory()) {
        self.additionsFactory = additionsFactory
    }
    
    public func makeShowListGateway(for application: DvrApplication) -> ShowListGateway {
        return ShowListGateway(builder: additionsFactory.makeDvrRequestBuilder(for: application),
                               parser: additionsFactory.makeDvrResponseParser(for: application))
    }
    
    public func makeShowDetailsGateway(for application: DvrApplication, show: DvrShow) -> ShowDetailsGateway {
        let gateway = ShowDetailsGateway(show: show,
                                         builder: additionsFactory.makeDvrRequestBuilder(for: application),
                                         parser: additionsFactory.makeDvrResponseParser(for: application))
        
        return gateway
    }
}
