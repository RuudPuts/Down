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

    let title = "Upcoming" //! localize

    var input = Input()
    lazy var output = transform(input: input)

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DvrAiringSoonViewModel: ReactiveBindable {
    struct Input {
        let itemSelected = PublishSubject<IndexPath>()
    }

    struct Output {
        let sections: Observable<[TableSectionData<RefinedEpisode>]>
        let episodeSelected: Observable<DvrEpisode>
    }
}

extension DvrAiringSoonViewModel {
    func transform(input: Input) -> Output {
        let airingToday = dependencies.database.fetchEpisodes(airingOn: Date()).map {
            $0.filter { $0.show != nil && $0.season != nil }
              .filter { !$0.isSpecial }
        }

        let airingTomorrow = dependencies.database.fetchEpisodes(airingOn: Date.tomorrow).map {
            $0.filter { $0.show != nil && $0.season != nil }
              .filter { !$0.isSpecial }
        }

        let airingSoon = dependencies.database.fetchEpisodes(airingBetween: Date().addingDays(2), and: Date().addingDays(14)).map {
            $0.filter { $0.show != nil && $0.season != nil }
              .filter { !$0.isSpecial }
        }

        let episodes = Observable.zip([airingToday, airingTomorrow, airingSoon])

        let episodeSelected = input.itemSelected
            .withLatestFrom(episodes) { indexPath, episodes in
                return episodes[indexPath.section][indexPath.row]
            }

        let sections = [
                (title: "Airing today", emptyMessage: "No episodes airing today", episodes: airingToday),
                (title: "Airing tomorrow", emptyMessage: "No episodes airing tomorrow", episodes: airingTomorrow),
                (title: "Airing soon", emptyMessage: "No episodes airing soon", episodes: airingSoon)
            ]
            .map { data in
                data.episodes.map { episodes -> TableSectionData<RefinedEpisode> in
                    let items = episodes
                        .map {
                            RefinedEpisode.from(episode: $0, withDvrRequestBuilder: self.dependencies.dvrRequestBuilder)
                        }

                    return TableSectionData(
                        header: data.title,
                        icon: nil,
                        items: items,
                        emptyMessage: data.emptyMessage
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
                                  showAndIdentifier: "\(show.name) - \(episode.seasonIdentifierString!)",
                                  airingOn: "Airs \(show.airTime) on \(show.network)",
                                  bannerUrl: requestBuilder.url(for: .fetchBanner(show)))

        }
    }
}
