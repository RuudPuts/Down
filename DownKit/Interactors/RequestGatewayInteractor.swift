//
//  RequestGatewayInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol RequestGatewayInteracting: ObservableInteractor where Element == Gateway.ResultType {
    associatedtype Gateway: RequestGateway
    
    var gateway: Gateway { get }
}

extension RequestGatewayInteracting {
    public func observe() -> Observable<Gateway.ResultType> {
        return gateway.observe()
    }
}

public final class RequestGatewayInteractor<Gateway: RequestGateway>: RequestGatewayInteracting {
    public var gateway: Gateway
    
    public init(gateway: Gateway) {
        self.gateway = gateway
    }
}
