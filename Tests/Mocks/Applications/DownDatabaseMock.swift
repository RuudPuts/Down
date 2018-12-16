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
    }

    struct Captures {
        // DvrDatabase
        var storeShows: Shows?
        var deleteShow: Show?
        var fetchShows: Bool?
        var fetchShowsMatching: FetchShowsMatching?

        struct Shows {
            var shows: [DvrShow]
        }

        struct Show {
            var show: DvrShow
        }

        struct FetchShowsMatching {
            var nameComponents: [String]
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
