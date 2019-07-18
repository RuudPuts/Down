//
//  DvrSeasonHeaderViewModel.swift
//  Down
//
//  Created by Ruud Puts on 29/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa
import RxRealm

struct DvrSeasonTableHeaderViewModel: Depending {
    typealias Dependencies = DvrInteractorFactoryDependency
    let dependencies: Dependencies

    private let season: DvrSeason

    var input = Input()
    lazy var output = transform(input: input)

    static let settableStatusses: [DvrEpisodeStatus] = [
        .wanted,
        .skipped,
        .archived,
        .ignored
    ]

    init(dependencies: Dependencies, season: DvrSeason) {
        self.dependencies = dependencies
        self.season = season
    }
}

extension DvrSeasonTableHeaderViewModel: ReactiveBindable {
    struct Input {
        let setStatus = PublishSubject<DvrEpisodeStatus>()
    }

    struct Output {
        let season: Observable<RefinedSeason>
        let statusChanged: Observable<Swift.Result<Void, DownError>>
    }
}

extension DvrSeasonTableHeaderViewModel {
    func transform(input: Input) -> Output {
        let season = Observable.from(object: self.season)

        let statusChanged = input.setStatus
            .withLatestFrom(season) { status, season in
                return (season: season, status: status)
            }
            .flatMap {
                self.dependencies.dvrInteractorFactory
                    .makeSetSeasonStatusInteractor(for: self.dependencies.dvrApplication,
                                                   season: $0.season,
                                                   status: $0.status)
                    .observeResult()
            }
            .map { $0.map { _ in } }

        let refinedSeason = season.map { RefinedSeason.from(season: $0) }

        return Output(season: refinedSeason, statusChanged: statusChanged)
    }
}

extension DvrSeasonTableHeaderViewModel {
    struct RefinedSeason {
        let title: String

        static func from(season: DvrSeason) -> RefinedSeason {
            if season.isSpecials {
                return RefinedSeason(title: "Specials")
            }

            return RefinedSeason(title: "Season \(season.identifier)")
        }
    }
}
