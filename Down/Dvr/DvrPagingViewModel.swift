//
//  DvrPagingViewModel.swift
//  Down
//
//  Created by Ruud Puts on 22/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

struct DvrPagingViewModel: PagingViewModel, Depending {
    typealias Dependencies = DvrInteractorFactoryDependency & DatabaseDependency
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    var dataLoadDescription: String {
        return "Preparing show cache, hold on!"
    }

    func transform(input: PagingViewModelInput) -> PagingViewModelOutput {
        let loadingData = BehaviorSubject(value: false)

        let refreshCache = dependencies.dvrInteractorFactory
            .makeShowCacheRefreshInteractor(for: dependencies.dvrApplication)
            .observe()
            .asVoid()

        let showsAvailable = dependencies.database.fetchShows().map { !$0.isEmpty }

        let data = input.loadData
            .withLatestFrom(showsAvailable)
            .do(onNext: { loadingData.onNext(!$0) })
            .flatMap { _ in refreshCache }
            .do(onNext: { _ in loadingData.onNext(false) })
            .asDriver(onErrorJustReturn: Void())

        return PagingViewModelOutput(data: data, loadingData: loadingData.asDriver(onErrorJustReturn: false))
    }
}
