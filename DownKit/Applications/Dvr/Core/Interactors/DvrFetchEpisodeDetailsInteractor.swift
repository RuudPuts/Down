//
//  DvrFetchEpisodeDetailsInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class DvrFetchEpisodeDetailsInteractor: RequestGatewayInteracting {
    public typealias Gateway = DvrFetchEpisodeDetailsGateway
    public typealias Element = Gateway.ResultType
    public var gateway: Gateway

    private var database: DvrDatabase!

    public init(gateway: Gateway) {
        self.gateway = gateway
    }

    convenience init(gateway: Gateway, database: DvrDatabase) {
        self.init(gateway: gateway)
        self.database = database
    }

    public func observe() -> Single<DvrEpisode> {
        return gateway
            .observe()
            .do(onSuccess: {
                self.database.store(episode: $0)
            })
    }
}
