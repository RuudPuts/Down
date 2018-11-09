//
//  DvrDatabaseMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift

extension DownDatabaseMock { // DvrDatabase
    func store(show: DvrShow) {
        captures.storeShow = Captures.Show(show: show)
    }

    func delete(show: DvrShow) {
        captures.deleteShow = Captures.Show(show: show)
    }

    func fetchShows() -> Observable<[DvrShow]> {
        captures.fetchShows = true
        return Observable.just(stubs.fetchShows)
    }

    func fetchShow(matching nameComponents: [String]) -> Maybe<DvrShow> {
        captures.fetchShowsMatching = Captures.FetchShowsMatching(nameComponents: nameComponents)
        return Maybe.just(stubs.fetchShowsMatchingNameComponents)
    }
}
