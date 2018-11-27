//
//  RequestGatewayInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result

public protocol RequestGatewayInteracting: ObservableInteractor where Element == Gateway.Element {
    associatedtype Gateway: RequestGateway
    
    var gateway: Gateway { get }

    func observe() -> Single<Gateway.ResultType>
}

extension RequestGatewayInteracting {
    public func observe() -> Single<Gateway.ResultType> {
        return gateway.observe()
    }
}

public final class RequestGatewayInteractor<Gateway: RequestGateway>: RequestGatewayInteracting {
    public var gateway: Gateway
    
    public init(gateway: Gateway) {
        self.gateway = gateway
    }
}
