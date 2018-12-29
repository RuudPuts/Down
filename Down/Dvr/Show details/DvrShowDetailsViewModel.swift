//
//  DvrShowDetailsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 15/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa
import Result
import RxResult

struct DvrShowDetailsViewModel: Depending {
    typealias Dependencies = DvrInteractorFactoryDependency & DvrRequestBuilderDependency
    let dependencies: Dependencies

    private let show: DvrShow

    init(dependencies: Dependencies, show: DvrShow) {
        self.dependencies = dependencies
        self.show = show
    }
    
    var bannerUrl: URL? {
        return dependencies.dvrRequestBuilder.url(for: .fetchBanner(show))
    }

    var posterUrl: URL? {
        return dependencies.dvrRequestBuilder.url(for: .fetchPoster(show))
    }
}

extension DvrShowDetailsViewModel: ReactiveBindable {
    struct Input {
        let deleteShow: ControlEvent<Void>
    }

    struct Output {
        let refinedShow: Driver<RefinedShow>
        let showDeleted: Observable<Result<Void, DownError>>
    }

    func transform(input: Input) -> Output {
        let showDriver = Driver.just(show)
        let refinedShowDriver = showDriver.map {
            RefinedShow.from(show: $0, withDvrRequestBuilder: self.dependencies.dvrRequestBuilder)
        }

        let showDeletedDriver = input.deleteShow
            .flatMap {
                self.dependencies.dvrInteractorFactory
                    .makeDeleteShowInteractor(for: self.dependencies.dvrApplication, show: self.show)
                    .observeResult()
            }
            .map { $0.map { _ in } }

        return Output(refinedShow: refinedShowDriver, showDeleted: showDeletedDriver)
    }
}

extension DvrShowDetailsViewModel {
    struct RefinedShow {
        let name: String
        let airingOn: String
        let quality: Quality
        let status: DvrShowStatus
        let episodesAvailable: String

        let seasons: [RefinedSeason]

        let bannerUrl: URL?
        let posterUrl: URL?

        static func from(show: DvrShow, withDvrRequestBuilder requestBuilder: DvrRequestBuilding) -> RefinedShow {
            let refinedSeasons = show.seasons
                .sorted(by: { Int($0.identifier)! > Int($1.identifier)! })
                .map { RefinedSeason.from(season: $0) }

            let episodes = refinedSeasons.flatMap { $0.episodes }
            let downloadedEpisodes = episodes.filter { $0.status == .downloaded }

            return RefinedShow(name: show.name,
                               airingOn: "\(show.airTime) on \(show.network)",
                               quality: show.quality,
                               status: show.status,
                               episodesAvailable: "\(downloadedEpisodes.count) / \(episodes.count) episodes downloaded",
                               seasons: refinedSeasons,
                               bannerUrl: requestBuilder.url(for: .fetchBanner(show)),
                               posterUrl: requestBuilder.url(for: .fetchPoster(show)))
        }
    }

    struct RefinedSeason {
        let title: String
        let episodes: [RefinedEpisode]

        static func from(season: DvrSeason) -> RefinedSeason {
            let episodes = season.episodes
                .sorted(by: { Int($0.identifier)! > Int($1.identifier)! })
                .map { RefinedEpisode.from(episode: $0) }

            if season.isSpecials {
                return RefinedSeason(title: "Specials",
                    episodes: episodes)
            }

            return RefinedSeason(title: "Season \(season.identifier)",
                                 episodes: episodes)
        }
    }

    struct RefinedEpisode {
        let title: String
        let airingOn: String
        let status: DvrEpisodeStatus

        static func from(episode: DvrEpisode) -> RefinedEpisode {
            return RefinedEpisode(title: "\(episode.identifier). \(episode.name)",
                                  airingOn: episode.airdate?.dateString ?? R.string.localizable.dvr_episode_unaired(),
                                  status: episode.status)
        }
    }
}

private extension DvrShow {
    var sortedSeasons: [DvrSeason] {
        return seasons.sorted(by: { Int($0.identifier)! > Int($1.identifier)! })
    }
}

private extension DvrSeason {
    var sortedEpisodes: [DvrEpisode] {
        return episodes.sorted(by: { Int($0.identifier)! > Int($1.identifier)! })
    }
}
