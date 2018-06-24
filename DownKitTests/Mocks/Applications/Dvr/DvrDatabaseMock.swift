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
    }
    
    struct Captures {
        var storeShow: StoreShow?
        
        struct StoreShow {
            var show: DvrShow
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DvrDatabase
    
    func store(show: DvrShow) {
        captures.storeShow = Captures.StoreShow(show: show)
    }
    
    func fetchShows() -> Observable<[DvrShow]> {
        return stubs.fetchShows
    }
    
    func transact(block: @escaping () -> Void) {
        block()
    }
}
