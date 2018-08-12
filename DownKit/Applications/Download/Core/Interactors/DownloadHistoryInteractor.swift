//
//  DownloadHistoryInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class DownloadHistoryInteractor: RequestGatewayInteracting, DatabaseConsuming {
    public typealias Gateway = DownloadHistoryGateway
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
    
    public func observe() -> Observable<[DownloadItem]> {
        return self.gateway
            .observe()
            .flatMap { items -> Observable<[DownloadItem]> in
                guard items.count > 0 else {
                    return Observable.just([])
                }

                return Observable.zip(items.map { $0.match(with: self.database) })
            }
    }
}
