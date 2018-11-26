//
//  DownloadHistoryInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class DownloadHistoryInteractor: RequestGatewayInteracting, Depending {
    public typealias Dependencies = DatabaseDependency
    public let dependencies: Dependencies

    public typealias Gateway = DownloadHistoryGateway
    public typealias Element = Gateway.Element
    
    public var gateway: Gateway

    public init(dependencies: Dependencies, gateway: Gateway) {
        self.dependencies = dependencies
        self.gateway = gateway
    }
    
    public func observe() -> Single<[DownloadItem]> {
        return self.gateway
            .observe().map { $0.value! }
            .flatMap { items -> Single<[DownloadItem]> in
                guard items.count > 0 else {
                    return Single.just([])
                }

                return Single.zip(items.map {
                    //! There's a bug here when the database doesn't find a match
                    $0.match(with: self.dependencies.database)
                })
            }
    }
}
