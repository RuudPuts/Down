//
//  DvrRecentlyAiredViewModel.swift
//  Down
//
//  Created by Ruud Puts on 17/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

struct DvrRecentlyAiredViewModel: Depending {
    typealias Dependencies = DatabaseDependency & DvrRequestBuilderDependency
    let dependencies: Dependencies

    let title = "Recents" //! Localize

    var input = Input()
    lazy var output = transform(input: input)

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DvrRecentlyAiredViewModel: ReactiveBindable {
    struct Input {
        let itemSelected = PublishSubject<IndexPath>()
    }

    struct Output {
        let data: Observable<[RefinedEpisode]>
        let episodeSelected: Observable<DvrEpisode>
    }
}

extension DvrRecentlyAiredViewModel {
    func transform(input: Input) -> Output {
        let recentlyAired: Observable<[DvrEpisode]> = dependencies.database
            .fetchEpisodes(airingBetween: Date().addingDays(-14), and: Date().addingDays(-1))
            .removeSpecials()
            .map { $0.reversed() }

        let episodeSelected = input.itemSelected
            .withLatestFrom(recentlyAired) { indexPath, episodes in
                return episodes[indexPath.row]
            }

        let refinedEpisodes = recentlyAired.map {
            $0.map {
                RefinedEpisode.from(episode: $0, withDvrRequestBuilder: self.dependencies.dvrRequestBuilder)
            }
        }

        return Output(data: refinedEpisodes, episodeSelected: episodeSelected)
    }
}

extension DvrRecentlyAiredViewModel {
    struct RefinedEpisode {
        let title: String
        let showAndIdentifier: String
        let airedOn: String
        let status: DvrEpisodeStatus
        let bannerUrl: URL?

        static func from(episode: DvrEpisode, withDvrRequestBuilder requestBuilder: DvrRequestBuilding) -> RefinedEpisode {
            let show = episode.show!

            return RefinedEpisode(
                title: episode.name,
                showAndIdentifier: "\(show.name) - \(episode.seasonIdentifierString!)",
                airedOn: "Aired \(episode.airdate?.dayMonthString ?? "") on \(show.network)",
                status: episode.status,
                bannerUrl: requestBuilder.url(for: .fetchBanner(show))
            )
        }
    }
}
