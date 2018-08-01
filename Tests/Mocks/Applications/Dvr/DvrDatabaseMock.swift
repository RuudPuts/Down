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
        var fetchShowsMatchingNameComponents = Observable<DvrShow>.just(DvrShow(identifier: "", name: "", quality: ""))
    }
    
    struct Captures {
        var storeShow: StoreShow?
        var fetchShows: Bool?
        var fetchShowsMatching: FetchShowsMatching?
        
        struct StoreShow {
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
        captures.storeShow = Captures.StoreShow(show: show)
    }
    
    func fetchShows() -> Observable<[DvrShow]> {
        captures.fetchShows = true
        return stubs.fetchShows
    }
    
    func fetchShow(matching nameComponents: [String]) -> Observable<DvrShow> {
        captures.fetchShowsMatching = Captures.FetchShowsMatching(nameComponents: nameComponents)
        return stubs.fetchShowsMatchingNameComponents
    }
    
    func transact(block: @escaping () -> Void) {
        block()
    }
}
