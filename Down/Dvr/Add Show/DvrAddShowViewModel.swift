//
//  DvrAddShowViewModel.swift
//  Down
//
//  Created by Ruud Puts on 03/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift

struct DvrAddShowViewModel{//: Depending {
//    typealias Dependencies = DatabaseDependency
//    let dependencies: Dependencies

    var title = R.string.localizable.dvr_screen_add_show_title()

    let application: DvrApplication
    let interactorFactory: DvrInteractorProducing
    let disposeBag = DisposeBag()
    
    init(/*dependencies: Dependencies, */application: DvrApplication, interactorFactory: DvrInteractorProducing) {
//        self.dependencies = dependencies
        self.application = application
        self.interactorFactory = interactorFactory
    }

    func searchShows(query: String) -> Observable<[DvrShow]> {
        guard query.count > 0 else {
            return Observable.just([])
        }

        return interactorFactory
            .makeSearchShowsInteractor(for: application, query: query)
            .observe()
    }

    func add(show: DvrShow) -> Observable<DvrShow> {
        return interactorFactory
            .makeAddShowInteractor(for: application, show: show)
            .observe()
            .skip(1)
    }
}
