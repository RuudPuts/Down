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

    private let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DvrAddShowViewModel: ReactiveBindable {
    struct Input {
        let searchQuery: Driver<String>
        let showSelected: ControlEvent<IndexPath>
    }

    struct Output {
        let searchResults: Driver<[DvrShow]>
        let showAdded: Observable<DvrShow>
    }

    func transform(input: Input) -> Output {
        let searchResultsDriver = input.searchQuery
            .flatMap {
                self.dependencies.dvrInteractorFactory
                    .makeSearchShowsInteractor(for: self.dependencies.dvrApplication, query: $0)
                    .observe()
                    .asDriver(onErrorJustReturn: [])
            }

        let showAddedDriver = input.showSelected
            .withLatestFrom(searchResultsDriver) { indexPath, searchResults in
                searchResults[indexPath.row]
            }
            .flatMap {
                self.dependencies.dvrInteractorFactory
                    .makeAddShowInteractor(for: self.dependencies.dvrApplication, show: $0)
                    .observe()
            }

        return Output(searchResults: searchResultsDriver, showAdded: showAddedDriver)
    }
}
