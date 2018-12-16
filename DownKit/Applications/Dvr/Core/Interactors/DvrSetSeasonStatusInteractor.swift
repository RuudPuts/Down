//
//  DvrSetSeasonStatusInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

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

    public func observe() -> Single<DvrShow> {
        return interactors.setStatus
            .observe()
            .flatMap { _ in self.refreshShowDetails() }
    }

    private func refreshShowDetails() -> Single<DvrShow> {
        let show = self.interactors.setStatus.season.show!

        return interactors.showDetails
            .setShow(show)
            .observe()
            .do(onSuccess: {
                self.database.store(shows: [$0])
            })
    }
}
