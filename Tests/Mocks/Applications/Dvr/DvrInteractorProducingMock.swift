//
//  DvrInteractorProducingMock.swift
//  DownKit
//
//  Created by Ruud Puts on 09/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DvrInteractorProducingMock {
    struct Stubs {
        var database: DownDatabase = DownDatabaseMock()

        var showListInteractor: DvrShowListGateway?
        var makeShowDetailsInteractor: DvrShowDetailsGateway?
        var makeShowCacheRefreshInteractor: DvrRefreshShowCacheInteractor.Interactors?
        var makeSearchShowsInteractor: DvrSearchShowsGateway?
        var makeAddShowInteractor: DvrAddShowInteractor.Interactors?
        var makeDeleteShowInteractor: DvrDeleteShowGateway?
        var makeSetEpisodeStatusInteractor: DvrSetEpisodeStatusInteractor.Interactors?
        var makeSetSeasonStatusInteractor: DvrSetSeasonStatusInteractor.Interactors?
    }

    struct Captures {

    }

    var stubs = Stubs()
    var captures = Captures()
}

extension DvrInteractorProducingMock: DvrInteractorProducing {
    func makeShowListInteractor(for application: DvrApplication) -> DvrShowListInteractor {
        return DvrShowListInteractor(gateway: stubs.showListInteractor!)
    }

    func makeShowDetailsInteractor(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsInteractor {
        return DvrShowDetailsInteractor(gateway: stubs.makeShowDetailsInteractor!)
    }

    func makeShowCacheRefreshInteractor(for application: DvrApplication) -> DvrRefreshShowCacheInteractor {
        return DvrRefreshShowCacheInteractor(application: application, interactors: stubs.makeShowCacheRefreshInteractor!, database: stubs.database)
    }

    func makeSearchShowsInteractor(for application: DvrApplication, query: String) -> DvrSearchShowsInteractor {
        return DvrSearchShowsInteractor(gateway: stubs.makeSearchShowsInteractor!)
    }

    func makeAddShowInteractor(for application: DvrApplication, show: DvrShow) -> DvrAddShowInteractor {
        return DvrAddShowInteractor(interactors: stubs.makeAddShowInteractor!)
    }

    func makeDeleteShowInteractor(for application: DvrApplication, show: DvrShow) -> DvrDeleteShowInteractor {
        return DvrDeleteShowInteractor(gateway: stubs.makeDeleteShowInteractor!, database: stubs.database)
    }

    func makeSetEpisodeStatusInteractor(for application: DvrApplication, episode: DvrEpisode, status: DvrEpisodeStatus) -> DvrSetEpisodeStatusInteractor {
        return DvrSetEpisodeStatusInteractor(interactors: stubs.makeSetEpisodeStatusInteractor!, database: stubs.database)
    }

    func makeSetSeasonStatusInteractor(for application: DvrApplication, season: DvrSeason, status: DvrEpisodeStatus) -> DvrSetSeasonStatusInteractor {
        return DvrSetSeasonStatusInteractor(interactors: stubs.makeSetSeasonStatusInteractor!, database: stubs.database)
    }
}
