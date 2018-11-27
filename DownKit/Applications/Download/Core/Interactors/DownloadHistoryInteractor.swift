//
//  DownloadHistoryInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result

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
    
    public func observe() -> Single<Gateway.ResultType> {
        return self.gateway
            .observe()
            .flatMap { result -> Single<Result<[DownloadItem], DownKitError>> in
                guard let items = result.value, items.count > 0 else {
                    return Single.just(.success([]))
                }

                return Single.zip(items.map {
                        $0.match(with: self.dependencies.database)
                    })
                    .map { .success($0) }
            }
    }
}
