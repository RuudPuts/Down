//
//  DvrAddShowViewModel.swift
//  Down
//
//  Created by Ruud Puts on 03/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

struct DvrAddShowViewModel: Depending {
    typealias Dependencies = DvrApplicationDependency & DvrInteractorFactoryDependency
    let dependencies: Dependencies

    let title = R.string.localizable.dvr_screen_add_show_title()

    var input = Input()
    lazy var output = transform(input: input)

    private let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DvrAddShowViewModel: ReactiveBindable {
    struct Input {
        let searchQuery = PublishSubject<String>()
        let showSelected = PublishSubject<IndexPath>()
    }

    struct Output {
        let searchResults: Observable<[DvrShow]>
        let addingShow: Observable<DvrShow>
        let showAdded: Observable<Swift.Result<DvrShow, DownError>>
    }
}

extension DvrAddShowViewModel {
    func transform(input: Input) -> Output {
        let searchResultsDriver = input.searchQuery
            .asObservable()
            .flatMap {
                self.dependencies.dvrInteractorFactory
                    .makeSearchShowsInteractor(for: self.dependencies.dvrApplication, query: $0)
                    .observeResult()
                    .map { $0.value ?? [] }
        }

        let selectedShow = input.showSelected
            .withLatestFrom(searchResultsDriver) { indexPath, searchResults in
                searchResults[indexPath.row]
        }

        let showAddedDriver = selectedShow
            .flatMap {
                self.dependencies.dvrInteractorFactory
                    .makeAddShowInteractor(for: self.dependencies.dvrApplication, show: $0)
                    .observeResult()
        }

        return Output(searchResults: searchResultsDriver, addingShow: selectedShow, showAdded: showAddedDriver)
    }
}
