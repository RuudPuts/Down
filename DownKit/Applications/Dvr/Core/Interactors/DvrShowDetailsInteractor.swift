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
    
    func setShow(_ show: DvrShow) -> DvrShowDetailsInteractor {
        gateway.show = show
        
        return self
    }
}
