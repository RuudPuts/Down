//
//  DvrAddShowCacheInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RxSwiftExt
import Result

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
    
    public func observe() -> Single<DvrShowDetailsInteractor.Gateway.ResultType> {
        return interactors.addShow
            .observe()
            .flatMap { _ in self.refreshShowDetails() }
    }

    private func refreshShowDetails() -> Single<DvrShowDetailsInteractor.Gateway.ResultType> {
        let show = interactors.addShow.show!

        return interactors.showDetails
            .setShow(show)
            .observe()
            .asObservable()
            .retry(.delayed(maxCount: 5, time: 1))
            .do(onSuccess: {
                //! Again this line is sickbeard specific. Won't hurt others but shouldn't be here.
                $0.identifier = show.identifier

                $0.store(in: self.database)
            })
            .asSingle()
    }
}
