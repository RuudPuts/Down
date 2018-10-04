//
//  DvrRefreshShowCacheInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrRefreshShowCacheInteractor: CompoundInteractor, ObservableInteractor {
    public typealias Interactors = DvrInteractorProducing
    public var interactors: Interactors
    
    public typealias Element = DvrShowListInteractor.Element

    var application: DvrApplication!
    var database: DvrDatabase!
    let disposeBag = DisposeBag()
    
    public required init(interactors: Interactors) {
        self.interactors = interactors
    }
    
    convenience init(application: DvrApplication, interactors: Interactors, database: DvrDatabase) {
        self.init(interactors: interactors)
        self.application = application
        self.database = database
    }
    
    public func observe() -> Observable<[DvrShow]> {
        return interactors
            .makeShowListInteractor(for: application)
            .observe()
            .flatMap { shows in
                Observable.zip(shows.map {
                    self.interactors
                        .makeShowDetailsInteractor(for: self.application, show: $0)
                        .observe()
                        .do(onNext: {
                            $0.store(in: self.database)
                        })
                    }
                )
            }
    }
}
