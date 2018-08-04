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
        // swiftlint:disable force_try
        return try! self.gateway
            .observe()
            .do(onNext: { items in
                items.forEach { $0.match(with: self.database) }
            })
    }
}
