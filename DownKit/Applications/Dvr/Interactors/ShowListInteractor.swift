//
//  ShowListInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class ShowListInteractor: RequestGatewayInteractor {
    public typealias Gateway = ShowListGateway
    public var gateway: Gateway
    
    public init(gateway: Gateway) {
        self.gateway = gateway
    }
}
