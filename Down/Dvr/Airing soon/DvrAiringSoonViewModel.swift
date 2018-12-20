//
//  DvrAiringSoonViewModel.swift
//  Down
//
//  Created by Ruud Puts on 17/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

struct DvrAiringSoonViewModel: Depending {
    typealias Dependencies = DatabaseDependency & DvrRequestBuilderDependency
    let dependencies: Dependencies

    let title = "Upcoming"

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DvrAiringSoonViewModel: ReactiveBindable {
    struct Input {
        let itemSelected: Observable<IndexPath>
    }

    struct Output {
        let sections: Observable<[TableSectionData<RefinedEpisode>]>
        let episodeSelected: Observable<DvrEpisode>
    }

    func transform(input: Input) -> Output {
        let airingToday = dependencies.database.fetchEpisodes(airingOn: Date())
        let airingTomorrow = dependencies.database.fetchEpisodes(airingOn: Date.tomorrow)
        let airingSoon = dependencies.database.fetchEpisodes(airingBetween: Date().addDays(2), and: Date().addDays(14))

        let episodes = Observable.zip([airingToday, airingTomorrow, airingSoon])
        let episodeSelected = input.itemSelected
            .withLatestFrom(episodes) { indexPath, episodes in
                return episodes[indexPath.section][indexPath.row]
            }

        let sections = [
                (title: "Airing today", episodes: airingToday),
                (title: "Airing tomorrow", episodes: airingTomorrow),
                (title: "Airing soon", episodes: airingSoon)
            ]
            .map { data in
                data.episodes.map { episodes -> TableSectionData<RefinedEpisode> in
                    return TableSectionData(
                        header: data.title,
                        icon: nil,
                        items: episodes
                            .filter { $0.show != nil }
                            .filter { !$0.isSpecial }
                            .map {
                                RefinedEpisode.from(episode: $0, withDvrRequestBuilder: self.dependencies.dvrRequestBuilder)
                            }
                    )
                }
            }

        return Output(sections: Observable.zip(sections), episodeSelected: episodeSelected)
    }
}

extension DvrAiringSoonViewModel {
    struct RefinedEpisode {
        let title: String
        let showAndIdentifier: String
        let airingOn: String
        let bannerUrl: URL?

        static func from(episode: DvrEpisode, withDvrRequestBuilder requestBuilder: DvrRequestBuilding) -> RefinedEpisode {
            let show = episode.show!

            return RefinedEpisode(title: episode.name,
                                  showAndIdentifier: String(format: "%@ - S%02dE%02d", show.name, Int(episode.season.identifier)!, Int(episode.identifier)!),
                                  airingOn: "Airs \(show.airTime) on \(show.network)",
                                  bannerUrl: requestBuilder.url(for: .fetchBanner(show)))

        }
    }
}
