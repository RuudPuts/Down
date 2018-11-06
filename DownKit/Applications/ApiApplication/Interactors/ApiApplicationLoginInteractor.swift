//
//  ApiApplicationLoginInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class ApiApplicationLoginInteractor: RequestGatewayInteracting {
    public typealias Gateway = ApiApplicationLoginGateway
    public typealias Element = LoginResult

    public var gateway: ApiApplicationLoginGateway
    public var credentials: UsernamePassword?

    public required init(gateway: ApiApplicationLoginGateway) {
        self.gateway = gateway
    }

    public convenience init(gateway: ApiApplicationLoginGateway, credentials: UsernamePassword?) {
        self.init(gateway: gateway)

        self.credentials = credentials
    }
}
