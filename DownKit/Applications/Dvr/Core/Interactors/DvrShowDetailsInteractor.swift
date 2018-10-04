//
//  DvrShowDetailsInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class DvrShowDetailsInteractor: RequestGatewayInteracting {
    public typealias Gateway = DvrShowDetailsGateway
    public typealias Element = Gateway.ResultType
    public var gateway: Gateway
    
    public init(gateway: Gateway) {
        self.gateway = gateway
    }
    
    func setShow(_ show: DvrShow) -> Observable<DvrShow> {
        gateway.show = show
        
        return observe()
    }

    public func observe() -> Observable<DvrShow> {
        return gateway
            .observe()
            .do(onNext: { $0.identifier = self.gateway.show.identifier })
    }
}
