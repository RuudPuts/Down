//
//  DownloadQueueInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class DownloadQueueInteractor: RequestGatewayInteracting, DatabaseConsuming {
    public typealias Gateway = DownloadQueueGateway
    public typealias Element = Gateway.ResultType
    
    public var gateway: Gateway
    public var database: DownDatabase!

    public init(gateway: Gateway) {
        self.gateway = gateway
    }

    convenience init(gateway: Gateway, database: DownDatabase) {
        self.init(gateway: gateway)
        self.database = database
    }
    
    public func observe() -> Observable<DownloadQueue> {
        var queue: DownloadQueue!

        return self.gateway
            .observe()
            .do(onNext: { queue = $0 })
            .map { $0.items }
            .flatMap { items -> Observable<[DownloadItem]> in
                guard items.count > 0 else {
                    return Observable.just([])
                }

                return Observable.zip(items.map { $0.match(with: self.database) })
            }
            .map { _ in queue }
    }
}
