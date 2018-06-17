//
//  DvrInteractorFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrInteractorProducing {
    func makeShowListInteractor(for application: DvrApplication) -> ShowListInteractor
    func makeShowDetailsInteractor(for application: DvrApplication, show: DvrShow) -> ShowDetailsInteractor
}

public class DvrInteractorFactory: DvrInteractorProducing {
    var gatewayFactory: DvrGatewayProducing
    
    public init(gatewayFactory: DvrGatewayProducing = DvrGatewayFactory()) {
        self.gatewayFactory = gatewayFactory
    }
    
    public func makeShowListInteractor(for application: DvrApplication) -> ShowListInteractor {
        let gateway = gatewayFactory.makeShowListGateway(for: application)
        
        return ShowListInteractor(gateway: gateway)
    }
    
    public func makeShowDetailsInteractor(for application: DvrApplication, show: DvrShow) -> ShowDetailsInteractor {
        let gateway = gatewayFactory.makeShowDetailsGateway(for: application, show: show)
        
        return ShowDetailsInteractor(gateway: gateway)
    }
}
