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

struct DvrShowDetailsViewModel: Depending {
    typealias Dependencies = DvrInteractorFactoryDependency & DvrRequestBuilderDependency
    let dependencies: Dependencies
    
    var input = Input()
    lazy var output = transform(input: input)

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
        let deleteShow = PublishSubject<Void>()
    }

    struct Output {
        let refinedShow: Driver<RefinedShow>
        let showDeleted: Observable<Swift.Result<Void, DownError>>
    }
}

extension DvrShowDetailsViewModel {
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

        let seasons: [DvrSeason]

        let bannerUrl: URL?
        let posterUrl: URL?

        static func from(show: DvrShow, withDvrRequestBuilder requestBuilder: DvrRequestBuilding) -> RefinedShow {
            let seasons = show.reversedSeasons

            let episodes = seasons.flatMap { $0.episodes }
            let downloadedEpisodes = episodes.filter { $0.status == .downloaded }

            return RefinedShow(name: show.name,
                               airingOn: "\(show.airTime) on \(show.network)",
                               quality: show.quality,
                               status: show.status,
                               episodesAvailable: "\(downloadedEpisodes.count) / \(episodes.count) episodes downloaded",
                               seasons: seasons,
                               bannerUrl: requestBuilder.url(for: .fetchBanner(show)),
                               posterUrl: requestBuilder.url(for: .fetchPoster(show)))
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
