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
    func store(shows: [DvrShow]) {
        captures.storeShows = Captures.Shows(shows: shows)
    }

    func delete(show: DvrShow) {
        captures.deleteShow = Captures.Show(show: show)
    }

    func fetchShows() -> Observable<[DvrShow]> {
        captures.fetchShows = true
        return Observable.just(stubs.fetchShows)
    }

    func fetchShow(matching nameComponents: [String]) -> Single<DvrShow?> {
        captures.fetchShowsMatching = Captures.FetchShowsMatching(nameComponents: nameComponents)
        return Single.just(stubs.fetchShowsMatchingNameComponents)
    }

    public func fetchEpisodes(airingOn airDate: Date) -> Observable<[DvrEpisode]> {
        captures.fetchEpisodesAiringOn = Captures.FetchEpisodesAiringOn(airDate: airDate)
        return Observable.just(stubs.fetchEpisodesAiringOn)
    }

    public func fetchEpisodes(airingBetween fromDate: Date, and toDate: Date) -> Observable<[DvrEpisode]> {
        captures.fetchEpisodesAiringBetween = Captures.FetchEpisodesAiringBetween(fromDate: fromDate, toDate: toDate)
        return Observable.just(stubs.fetchEpisodesAiringBetween)
    }
}
