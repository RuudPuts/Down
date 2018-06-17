//
//  ShowDetailsInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class ShowDetailsInteractor: RequestGatewayInteractor {
    public typealias Gateway = ShowDetailsGateway
    public var gateway: Gateway
    
    public init(gateway: Gateway) {
        self.gateway = gateway
    }
}
