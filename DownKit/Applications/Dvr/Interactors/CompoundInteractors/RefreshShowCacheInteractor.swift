//
//  RefreshShowCacheInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class RefreshShowCacheInteractor: CompoundInteractor, ObservableInteractor {
    public typealias Interactors = (showList: ShowListInteractor, showDetails: ShowDetailsInteractor)
    public var interactors: Interactors
    
    public typealias Element = ShowListInteractor.Element
    var subject: Variable<Element> = Variable([])
    
    let disposeBag = DisposeBag()
    
    public required init(interactors: Interactors) {
        self.interactors = interactors
    }
    
    public func observe() -> Observable<[DvrShow]> {
        refreshShows()
        
        return subject.asObservable()
    }
    
    private func refreshShows() {
        interactors.showList
            .observe()
            .subscribe(onNext: {
                self.subject.value = $0
                self.refreshShowDetails()
            })
            .disposed(by: disposeBag)
    }
    
    private func refreshShowDetails() {
        self.subject.value.forEach { show in
            interactors.showDetails
                .setShow(show)
                .observe()
                .subscribe(onNext: { self.updateSubject(with: $0) })
                .disposed(by: disposeBag)
        }
    }
    
    private func updateSubject(with show: DvrShow) {
        var updatedShows = self.subject.value
        guard let showIndex = updatedShows.index(where: { $0.name == show.name }) else {
            return
        }
        
        let existingShow = updatedShows[showIndex]
        show.identifier = existingShow.identifier
        
        updatedShows.remove(at: showIndex)
        updatedShows.insert(show, at: showIndex)
        
        self.subject.value = updatedShows
    }
}
