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
    typealias Dependencies = DatabaseDependency & DvrInteractorFactoryDependency
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
        let data: Observable<[TableSectionData<DvrEpisode>]>
    }

    func transform(input: Input) -> Output {
        let airingToday = dependencies.database
            .fetchEpisodes(airingOn: Date())
            .map { TableSectionData(header: "Airing today", icon: nil, items: $0) }

        let airingTomorrow = dependencies.database
            .fetchEpisodes(airingOn: Date.tomorrow)
            .map { TableSectionData(header: "Airing tomorrow", icon: nil, items: $0) }

        let airingSoon = dependencies.database
            .fetchEpisodes(airingBetween: Date().addDays(2), and: Date().addDays(14))
            .map { TableSectionData(header: "Airing soon", icon: nil, items: $0) }

        return Output(data: Observable.zip([airingToday, airingTomorrow, airingSoon]))
    }
}
