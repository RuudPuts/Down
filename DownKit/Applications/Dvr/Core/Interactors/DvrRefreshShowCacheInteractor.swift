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
    var subject: Variable<Element> = Variable([])
    
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
        //! Do use flatmap, zip, map to merge all details observers into one
        refreshShows()
        
        return subject.asObservable()
    }
    
    private func refreshShows() {
        interactors.showList
            .observe()
            .subscribe(onNext: {
                self.refreshShowDetails(shows: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func refreshShowDetails(shows: [DvrShow]) {
        shows.forEach { show in
            interactors.showDetails
                .setShow(show)
                .observe()
                .map { show -> DvrShow in //! Though generic for shows, this map is sickbeard specific. Applications should have injection points in interactors?
                    if let index = shows.index(where: { $0.name == show.name }) {
                        show.identifier = shows[index].identifier
                    }
                    
                    return show
                }
                .subscribe(onNext: {
                    $0.store(in: self.database)
                })
                .disposed(by: disposeBag)
        }
    }
}
