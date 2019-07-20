//
//  DownDatabaseMock.swift
//  Down
//
//  Created by Ruud Puts on 09/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift

class DownDatabaseMock {
    struct Stubs {
        // DvrDatabase
        var fetchShows = [DvrShow]()
        var fetchShowsMatchingNameComponents: DvrShow?
        var fetchEpisodesAiringOn = [DvrEpisode]()
        var fetchEpisodesAiringBetween = [DvrEpisode]()
    }

    struct Captures {
        // DvrDatabase
        var clearDvrDatabase: ClearDvrDatabase?
        var storeShows: StoreShows?
        var deleteShow: DeleteShow?
        var fetchShows: Bool?
        var fetchShowsMatching: FetchShowsMatching?
        var storeEpisode: StoreEpisode?
        var fetchEpisodesAiringOn: FetchEpisodesAiringOn?
        var fetchEpisodesAiringBetween: FetchEpisodesAiringBetween?

        struct ClearDvrDatabase {
        }

        struct StoreShows {
            var shows: [DvrShow]
        }

        struct DeleteShow {
            var show: DvrShow
        }

        struct FetchShowsMatching {
            var nameComponents: [String]
        }

        struct StoreEpisode {
            var episode: DvrEpisode
        }

        struct FetchEpisodesAiringOn {
            var airDate: Date
        }

        struct FetchEpisodesAiringBetween {
            var fromDate: Date
            var toDate: Date
        }
    }

    var stubs = Stubs()
    var captures = Captures()
}

extension DownDatabaseMock: DownDatabase {
    func transact(block: @escaping () -> Void) {
        block()
    }
}
