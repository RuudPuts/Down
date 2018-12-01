//
//  DvrShowsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 03/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

struct DvrShowsViewModel: Depending {
    typealias Dependencies = DatabaseDependency & DvrInteractorFactoryDependency
    let dependencies: Dependencies

    let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DvrShowsViewModel: ReactiveBindable {
    struct Input { }

    struct Output {
        let refreshShowCache: Single<Void>
        let shows: Driver<[DvrShow]>
    }

    func transform(input: Input) -> Output {
        let refreshCacheSingle = dependencies.dvrInteractorFactory
            .makeShowCacheRefreshInteractor(for: dependencies.dvrApplication)
            .observe()
            .asVoid()

        let showsDriver = dependencies.database
            .fetchShows()
            .map { $0.sorted(by: { $0.name < $1.name }) }
            .asDriver(onErrorJustReturn: [])

        return Output(refreshShowCache: refreshCacheSingle, shows: showsDriver)
    }
}
