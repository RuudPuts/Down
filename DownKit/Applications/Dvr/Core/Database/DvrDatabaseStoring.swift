//
//  DvrDataStorage.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol DvrDatabase: Database {
    func clearDvrDatabase()
    func store(shows: [DvrShow])
    func delete(show: DvrShow)
    func fetchShows() -> Observable<[DvrShow]>
    func fetchShow(matching nameComponents: [String]) -> Single<DvrShow?>
    func store(episode: DvrEpisode)
    func fetchEpisodes(airingOn airDate: Date) -> Observable<[DvrEpisode]>
    func fetchEpisodes(airingBetween fromDate: Date, and toDate: Date) -> Observable<[DvrEpisode]>
}
