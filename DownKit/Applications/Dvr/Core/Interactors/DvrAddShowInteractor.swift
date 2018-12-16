//
//  DvrAddShowCacheInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RxSwiftExt

public class DvrAddShowInteractor: CompoundInteractor {
    public typealias Interactors = (addShow: DvrAddShowGateway, showDetails: DvrShowDetailsInteractor)
    public var interactors: Interactors
    
    public typealias Element = DvrShowDetailsInteractor.Element
    
    var database: DvrDatabase!
    
    public required init(interactors: Interactors) {
        self.interactors = interactors
    }
    
    convenience init(interactors: Interactors, database: DvrDatabase) {
        self.init(interactors: interactors)
        self.database = database
    }
    
    public func observe() -> Single<DvrShow> {
        return interactors.addShow
            .observe()
            .flatMap { _ in self.refreshShowDetails() }
    }

    private func refreshShowDetails() -> Single<DvrShow> {
        let show = interactors.addShow.show!

        return interactors.showDetails
            .setShow(show)
            .observe()
            .asObservable()
            .retry(.delayed(maxCount: 5, time: 1))
            .do(onNext: {
                // Required for sickbeard / sickgear
                $0.identifier = show.identifier

                self.database.store(shows: [$0])
            })
            .asSingle()
    }
}
