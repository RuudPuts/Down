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
    
    // Compound interactors
    func makeShowCacheRefreshInteractor(for application: DvrApplication) -> RefreshShowCacheInteractor
}

public class DvrInteractorFactory: DvrInteractorProducing {
    var database: DvrDatabase
    var gatewayFactory: DvrGatewayProducing
    
    public init(database: DvrDatabase, gatewayFactory: DvrGatewayProducing = DvrGatewayFactory()) {
        self.gatewayFactory = gatewayFactory
        self.database = database
    }
    
    public func makeShowListInteractor(for application: DvrApplication) -> ShowListInteractor {
        let gateway = gatewayFactory.makeShowListGateway(for: application)
        
        return ShowListInteractor(gateway: gateway)
    }
    
    public func makeShowDetailsInteractor(for application: DvrApplication, show: DvrShow) -> ShowDetailsInteractor {
        let gateway = gatewayFactory.makeShowDetailsGateway(for: application, show: show)
        
        return ShowDetailsInteractor(gateway: gateway)
    }
    
    public func makeShowCacheRefreshInteractor(for application: DvrApplication) -> RefreshShowCacheInteractor {
        let showListInteractor = makeShowListInteractor(for: application)
        let showDetailsInteractor = makeShowDetailsInteractor(for: application, show: DvrShow(identifier: "", name: "", quality: ""))
        let interactors = (showList: showListInteractor, showDetails: showDetailsInteractor)
        
        return RefreshShowCacheInteractor(interactors: interactors, database: database)
    }
}
