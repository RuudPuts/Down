//
//  DvrDatabaseMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift

class DvrDatabaseMock: DvrDatabase {
    struct Stubs {
        var fetchShows = Observable<[DvrShow]>.just([])
        var fetchShowsMatchingNameComponents = Maybe<DvrShow>.just(DvrShow())
    }
    
    struct Captures {
        var storeShow: Show?
        var deleteShow: Show?
        var fetchShows: Bool?
        var fetchShowsMatching: FetchShowsMatching?
        
        struct Show {
            var show: DvrShow
        }

        struct FetchShowsMatching {
            var nameComponents: [String]
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DvrDatabase
    
    func store(show: DvrShow) {
        captures.storeShow = Captures.Show(show: show)
    }

    func delete(show: DvrShow) {
        captures.deleteShow = Captures.Show(show: show)
    }
    
    func fetchShows() -> Observable<[DvrShow]> {
        captures.fetchShows = true
        return stubs.fetchShows
    }
    
    func fetchShow(matching nameComponents: [String]) -> Maybe<DvrShow> {
        captures.fetchShowsMatching = Captures.FetchShowsMatching(nameComponents: nameComponents)
        return stubs.fetchShowsMatchingNameComponents
    }
    
    func transact(block: @escaping () -> Void) {
        block()
    }
}
