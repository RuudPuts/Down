//
//  DvrInteractorFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrInteractorProducing {
    func makeShowListInteractor(for application: DvrApplication) -> DvrShowListInteractor
    func makeShowDetailsInteractor(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsInteractor
    func makeShowCacheRefreshInteractor(for application: DvrApplication) -> DvrRefreshShowCacheInteractor

    func makeSearchShowsInteractor(for application: DvrApplication, query: String) -> DvrSearchShowsInteractor
    func makeAddShowInteractor(for application: DvrApplication, show: DvrShow) -> DvrAddShowInteractor
    func makeDeleteShowInteractor(for application: DvrApplication, show: DvrShow) -> DvrDeleteShowInteractor

    func makeSetEpisodeStatusInteractor(for application: DvrApplication, episode: DvrEpisode, status: DvrEpisodeStatus) -> DvrSetEpisodeStatusInteractor
    func makeSetSeasonStatusInteractor(for application: DvrApplication, season: DvrSeason, status: DvrEpisodeStatus) -> DvrSetSeasonStatusInteractor
}

public class DvrInteractorFactory: DvrInteractorProducing, Depending {
    public typealias Dependencies = DatabaseDependency & DvrGatewayFactoryDependency
    public let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeShowListInteractor(for application: DvrApplication) -> DvrShowListInteractor {
        let gateway = dependencies.dvrGatewayFactory.makeShowListGateway(for: application)
        
        return DvrShowListInteractor(gateway: gateway)
    }
    
    public func makeShowDetailsInteractor(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsInteractor {
        let gateway = dependencies.dvrGatewayFactory.makeShowDetailsGateway(for: application, show: show)
        
        return DvrShowDetailsInteractor(gateway: gateway)
    }
    
    public func makeShowCacheRefreshInteractor(for application: DvrApplication) -> DvrRefreshShowCacheInteractor {
        return DvrRefreshShowCacheInteractor(application: application, interactors: self, database: dependencies.database)
    }

    public func makeSearchShowsInteractor(for application: DvrApplication, query: String) -> DvrSearchShowsInteractor {
        let gateway = dependencies.dvrGatewayFactory.makeSearchShowsGateway(for: application, query: query)

        return DvrSearchShowsInteractor(gateway: gateway)
    }

    public func makeAddShowInteractor(for application: DvrApplication, show: DvrShow) -> DvrAddShowInteractor {
        let gateway = dependencies.dvrGatewayFactory.makeAddShowGateway(for: application, show: show)
        let showDetailsInteractor = makeShowDetailsInteractor(for: application, show: show)
        let interactors = (addShow: gateway, showDetails: showDetailsInteractor)

        return DvrAddShowInteractor(interactors: interactors, database: dependencies.database)
    }

    public func makeDeleteShowInteractor(for application: DvrApplication, show: DvrShow) -> DvrDeleteShowInteractor {
        let gateway = dependencies.dvrGatewayFactory.makeDeleteShowGateway(for: application, show: show)

        return DvrDeleteShowInteractor(gateway: gateway, database: dependencies.database)
    }

    public func makeSetEpisodeStatusInteractor(for application: DvrApplication, episode: DvrEpisode, status: DvrEpisodeStatus) -> DvrSetEpisodeStatusInteractor {
        let gateway = dependencies.dvrGatewayFactory.makeSetEpisodeStatusGateway(for: application, episode: episode, status: status)
        let showDetailsInteractor = makeShowDetailsInteractor(for: application, show: episode.show)
        let interactors = (setStatus: gateway, showDetails: showDetailsInteractor)
        
        return DvrSetEpisodeStatusInteractor(interactors: interactors, database: dependencies.database)
    }

    public func makeSetSeasonStatusInteractor(for application: DvrApplication, season: DvrSeason, status: DvrEpisodeStatus) -> DvrSetSeasonStatusInteractor {
        let gateway = dependencies.dvrGatewayFactory.makeSetSeasonStatusGateway(for: application, season: season, status: status)
        let showDetailsInteractor = makeShowDetailsInteractor(for: application, show: season.show)
        let interactors = (setStatus: gateway, showDetails: showDetailsInteractor)

        return DvrSetSeasonStatusInteractor(interactors: interactors, database: dependencies.database)
    }
}
