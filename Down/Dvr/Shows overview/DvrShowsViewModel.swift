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
    typealias Dependencies = DatabaseDependency
    let dependencies: Dependencies

    let refreshCacheInteractor: DvrRefreshShowCacheInteractor
    let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies, refreshCacheInteractor: DvrRefreshShowCacheInteractor) {
        self.dependencies = dependencies
        self.refreshCacheInteractor = refreshCacheInteractor
    }

    var shows: Observable<[DvrShow]> {
        return dependencies.database
            .fetchShows()
            .map {
                return $0.sorted(by: { $0.name < $1.name })
            }
    }

    func refreshShowCache() {
        refreshCacheInteractor
            .observe()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
