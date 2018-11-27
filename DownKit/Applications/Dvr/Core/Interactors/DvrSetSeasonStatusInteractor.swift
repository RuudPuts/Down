//
//  DvrSetSeasonStatusInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result
import RxResult

public class DvrSetSeasonStatusInteractor: CompoundInteractor {
    public typealias Interactors = (setStatus: DvrSetSeasonStatusGateway, showDetails: DvrShowDetailsInteractor)
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
        return interactors.setStatus
            .observe()
            .flatMap { _ in self.refreshShowDetails() }
    }

    private func refreshShowDetails() -> Single<DvrShowDetailsInteractor.Gateway.ResultType> {
        let show = self.interactors.setStatus.season.show!

        return interactors.showDetails
            .setShow(show)
            .observe()
            .asObservable()
            .do(onSuccess: {
                $0.store(in: self.database)
            })
            .asSingle()
    }
}
