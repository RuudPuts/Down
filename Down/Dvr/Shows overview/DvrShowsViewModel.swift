//
//  DvrShowsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 03/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxDataSources

class DvrShowsViewModel: Depending {
    typealias Dependencies = DatabaseDependency & DvrInteractorFactoryDependency
    let dependencies: Dependencies

    let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    var shows: Observable<[DvrShow]> {
        return dependencies.database
            .fetchShows()
            .map {
                return $0.sorted(by: { $0.name < $1.name })
            }
    }

    func refreshShowCache() {
        dependencies.dvrInteractorFactory
            .makeShowCacheRefreshInteractor(for: dependencies.dvrApplication)
            .observe()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
