//
//  DvrAddShowViewModel.swift
//  Down
//
//  Created by Ruud Puts on 03/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift

struct DvrAddShowViewModel: Depending {
    typealias Dependencies = DvrApplicationDependency & DvrInteractorFactoryDependency
    let dependencies: Dependencies

    let title = R.string.localizable.dvr_screen_add_show_title()

    private let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func searchShows(query: String) -> Observable<[DvrShow]> {
        guard query.count > 0 else {
            return Observable.just([])
        }

        return dependencies.dvrInteractorFactory
            .makeSearchShowsInteractor(for: dependencies.dvrApplication, query: query)
            .observe()
    }

    func add(show: DvrShow) -> Observable<DvrShow> {
        return dependencies.dvrInteractorFactory
            .makeAddShowInteractor(for: dependencies.dvrApplication, show: show)
            .observe()
            .skip(1)
    }
}
