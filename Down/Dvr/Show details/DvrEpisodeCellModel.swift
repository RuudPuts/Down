//
//  DvrEpisodeCellModel.swift
//  Down
//
//  Created by Ruud Puts on 29/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa
import RxRealm
import Result

struct DvrEpisodeCellModel: Depending {
    typealias Dependencies = DvrInteractorFactoryDependency
    let dependencies: Dependencies

    private let episode: DvrEpisode

    var input = Input()
    lazy var output = transform(input: input)

    static let settableStatusses: [DvrEpisodeStatus] = [
        .wanted,
        .skipped,
        .archived,
        .ignored,
        .downloaded
    ]

    init(dependencies: Dependencies, episode: DvrEpisode) {
        self.dependencies = dependencies
        self.episode = episode
    }
}

extension DvrEpisodeCellModel: ReactiveBindable {
    struct Input {
        let setStatus = PublishSubject<DvrEpisodeStatus>()
        let fetchPlot = PublishSubject<Void>()
    }

    struct Output {
        let episode: Observable<RefinedEpisode>
        let plotFetched: Observable<Void>
        let statusChanged: Observable<Result<Void, DownError>>
    }
}

extension DvrEpisodeCellModel {
    func transform(input: Input) -> DvrEpisodeCellModel.Output {
        let episode = Observable.from(object: self.episode)

        let plotFetched = input.fetchPlot
            .withLatestFrom(episode)
            .flatMap {
                self.dependencies.dvrInteractorFactory
                    .makeFetchEpisodeDetailsInteractor(for: self.dependencies.dvrApplication, episode: $0)
                    .observe()
            }
            .map { _ in Void() }

        let statusChanged = input.setStatus
            .withLatestFrom(episode) { status, episode in
                return (episode: episode, status: status)
            }
            .filter { $0.episode.status != $0.status }
            .flatMap {
                self.dependencies.dvrInteractorFactory
                    .makeSetEpisodeStatusInteractor(for: self.dependencies.dvrApplication,
                                                    episode: $0.episode,
                                                    status: $0.status)
                    .observeResult()
            }
            .map { $0.map { _ in Void() } }

        let refinedEpisode = episode.map { RefinedEpisode.from(episode: $0) }

        return Output(episode: refinedEpisode, plotFetched: plotFetched, statusChanged: statusChanged)
    }
}

extension DvrEpisodeCellModel {
    struct RefinedEpisode {
        let title: String
        let plot: String?
        let airingOn: String
        let status: DvrEpisodeStatus
        let statusDescription: String

        static func from(episode: DvrEpisode) -> RefinedEpisode {
            var statusDescription = episode.status.displayString
            if episode.quality != .unknown {
                statusDescription = "\(statusDescription) (\(episode.quality.displayString))"
            }

            var airingOn = R.string.localizable.dvr_episode_unaired()
            if let airDate = episode.airdate {
                airingOn = "\(airDate.isInThePast ? "Aired" : "Airs") \(airDate.dateString)"
            }

            return RefinedEpisode(title: "\(episode.identifier). \(episode.name)",
                plot: episode.summary,
                airingOn: airingOn,
                status: episode.status,
                statusDescription: statusDescription)
        }
    }
}
