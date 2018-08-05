//
//  DvrViewModel.swift
//  Down
//
//  Created by Ruud Puts on 03/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxDataSources

struct DvrViewModel {
    var title = R.string.localizable.screen_dvr_root_title()
    
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
            .do(onNext: {
                if $0.count == 0 {
                    self.refreshShowCache()
                }
            })
    }
}

private extension DvrViewModel {
    func refreshShowCache() {
        refreshCacheInteractor
            .observe()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
