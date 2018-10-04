//
//  DvrRefreshShowCacheInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrRefreshShowCacheInteractor: CompoundInteractor, ObservableInteractor {
    public typealias Interactors = (showList: DvrShowListInteractor, showDetails: DvrShowDetailsInteractor)
    public var interactors: Interactors
    
    public typealias Element = DvrShowListInteractor.Element

    var database: DvrDatabase!
    let disposeBag = DisposeBag()
    
    public required init(interactors: Interactors) {
        self.interactors = interactors
    }
    
    convenience init(interactors: Interactors, database: DvrDatabase) {
        self.init(interactors: interactors)
        self.database = database
    }
    
    public func observe() -> Observable<[DvrShow]> {
        return interactors.showList
            .observe()
            .flatMap { shows in
                Observable.zip(shows.map {
                    self.interactors.showDetails
                        .setShow($0)
                        .map { show -> DvrShow in
                            //! Though generic for shows, this map is sickbeard specific.
                            // Applications should have injection points in interactors?
                            if let index = shows.index(where: { $0.name == show.name }) {
                                show.identifier = shows[index].identifier
                            }

                            return show
                        }
                        .do(onNext: {
                            $0.store(in: self.database)
                        })
                    }
                )
            }
    }
}
