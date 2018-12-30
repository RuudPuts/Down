//
//  DvrGatewayFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrGatewayProducing {
    func makeShowListGateway(for application: DvrApplication) -> DvrShowListGateway
    func makeShowDetailsGateway(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsGateway
    
    func makeSearchShowsGateway(for application: DvrApplication, query: String) -> DvrSearchShowsGateway
    func makeAddShowGateway(for application: DvrApplication, show: DvrShow) -> DvrAddShowGateway
    func makeDeleteShowGateway(for application: DvrApplication, show: DvrShow) -> DvrDeleteShowGateway

    func makeSetEpisodeStatusGateway(for application: DvrApplication, episode: DvrEpisode, status: DvrEpisodeStatus) -> DvrSetEpisodeStatusGateway
    func makeSetSeasonStatusGateway(for application: DvrApplication, season: DvrSeason, status: DvrEpisodeStatus) -> DvrSetSeasonStatusGateway

    func makeFetchEpisodeDetailsGateway(for application: DvrApplication, episode: DvrEpisode) -> DvrFetchEpisodeDetailsGateway
}

public class DvrGatewayFactory: DvrGatewayProducing, Depending {
    public typealias Dependencies = ApplicationAdditionsFactoryDependency
    public let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeShowListGateway(for application: DvrApplication) -> DvrShowListGateway {
        return DvrShowListGateway(builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                  parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }
    
    public func makeShowDetailsGateway(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsGateway {
        return DvrShowDetailsGateway(show: show,
                                     builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                     parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeSearchShowsGateway(for application: DvrApplication, query: String) -> DvrSearchShowsGateway {
        return DvrSearchShowsGateway(query: query,
                                     builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                     parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeAddShowGateway(for application: DvrApplication, show: DvrShow) -> DvrAddShowGateway {
        return DvrAddShowGateway(show: show,
                                 builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                 parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeDeleteShowGateway(for application: DvrApplication, show: DvrShow) -> DvrDeleteShowGateway {
        return DvrDeleteShowGateway(show: show,
                                    builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                    parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeSetEpisodeStatusGateway(for application: DvrApplication, episode: DvrEpisode, status: DvrEpisodeStatus) -> DvrSetEpisodeStatusGateway {
        return DvrSetEpisodeStatusGateway(episode: episode,
                                          status: status,
                                          builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                          parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeSetSeasonStatusGateway(for application: DvrApplication, season: DvrSeason, status: DvrEpisodeStatus) -> DvrSetSeasonStatusGateway {
        return DvrSetSeasonStatusGateway(season: season,
                                         status: status,
                                         builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                         parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeFetchEpisodeDetailsGateway(for application: DvrApplication, episode: DvrEpisode) -> DvrFetchEpisodeDetailsGateway {
        return DvrFetchEpisodeDetailsGateway(episode: episode,
                                             builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                             parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }
}
