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

class DvrShowsViewModel {
    let refreshCacheInteractor: DvrRefreshShowCacheInteractor
    let database: DvrDatabase
    let disposeBag = DisposeBag()
    
    init(database: DvrDatabase, refreshCacheInteractor: DvrRefreshShowCacheInteractor) {
        self.database = database
        self.refreshCacheInteractor = refreshCacheInteractor
    }

    var shows: Observable<[DvrShow]> {
        return database
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
