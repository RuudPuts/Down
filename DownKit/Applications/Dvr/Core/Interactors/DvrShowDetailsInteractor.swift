//
//  DvrShowDetailsInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result
import RxResult

public final class DvrShowDetailsInteractor: RequestGatewayInteracting {
    public typealias Gateway = DvrShowDetailsGateway
    public typealias Element = Gateway.Element
    public var gateway: Gateway
    
    public init(gateway: Gateway) {
        self.gateway = gateway
    }
    
    func setShow(_ show: DvrShow) -> DvrShowDetailsInteractor {
        gateway.show = show
        
        return self
    }
    public func observe() -> Single<Gateway.ResultType> {
        return gateway
            .observe()
            .asObservable()
            .do(onSuccess: { $0.identifier = self.gateway.show.identifier })
            .asSingle()
    }
}
