//
//  DownloadQueueInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class DownloadQueueInteractor: RequestGatewayInteracting, Depending {
    public typealias Dependencies = DatabaseDependency
    public let dependencies: Dependencies

    public typealias Gateway = DownloadQueueGateway
    public typealias Element = Gateway.Element
    
    public var gateway: Gateway

    public init(dependencies: Dependencies, gateway: Gateway) {
        self.dependencies = dependencies
        self.gateway = gateway
    }
    
    public func observe() -> Single<DownloadQueue> {
        var queue: DownloadQueue!

        return self.gateway
            .observe().map { $0.value! }
            .do(onSuccess: { queue = $0 })
            .map { $0.items }
            .flatMap { items -> Single<[DownloadItem]> in
                guard items.count > 0 else {
                    return Single.just([])
                }

                return Single.zip(items.map {
                    $0.match(with: self.dependencies.database)
                })
            }
            .map { _ in queue }
    }
}
