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

    let title = "Airing soon"

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DvrAiringSoonViewModel: ReactiveBindable {
    struct Input { }

    struct Output {
        let data: Observable<[TableSectionData<RefinedEpisode>]>
    }

    func transform(input: Input) -> Output {
        let airingToday = dependencies.database
            .fetchEpisodes(airingOn: Date())
            .map { $0.map { RefinedEpisode.from(episode: $0, withDvrRequestBuilder: self.dependencies.dvrRequestBuilder) } }
            .map { TableSectionData(header: "Airing today", icon: nil, items: $0) }

        let airingTomorrow = dependencies.database
            .fetchEpisodes(airingOn: Date.tomorrow)
            .map { $0.map { RefinedEpisode.from(episode: $0, withDvrRequestBuilder: self.dependencies.dvrRequestBuilder) } }
            .map { TableSectionData(header: "Airing tomorrow", icon: nil, items: $0) }

        let airingSoon = dependencies.database
            .fetchEpisodes(airingBetween: Date().addDays(2), and: Date().addDays(14))
            .map { $0.map { RefinedEpisode.from(episode: $0, withDvrRequestBuilder: self.dependencies.dvrRequestBuilder) } }
            .map { TableSectionData(header: "Airing soon", icon: nil, items: $0) }

        return Output(data: Observable.zip([airingToday, airingTomorrow, airingSoon]))
    }
}

extension DvrAiringSoonViewModel {
    struct RefinedEpisode {
        let showName: String
        let seasonAndEpisode: String
        let airingOn: String

        let bannerUrl: URL?

        static func from(episode: DvrEpisode, withDvrRequestBuilder requestBuilder: DvrRequestBuilding) -> RefinedEpisode {
            let show = episode.show!

            return RefinedEpisode(showName: show.name,
                                  seasonAndEpisode: "Season \(episode.season.identifier) episode \(episode.identifier)",
                                  airingOn: "Airs \(show.airTime) on \(show.network)",
                                  bannerUrl: requestBuilder.url(for: .fetchBanner(show)))

        }
    }
}
