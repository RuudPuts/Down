//
//  ApiApplicationInteractorFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ApiApplicationInteractorProducing {
    func makeLoginInteractor(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationLoginInteractor
    func makeApiKeyInteractor(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationApiKeyInteractor
}

public class ApiApplicationInteractorFactory: ApiApplicationInteractorProducing {
    var gatewayFactory: ApiApplicationGatewayProducing
    
    public init(gatewayFactory: ApiApplicationGatewayProducing = ApiApplicationGatewayFactory()) {
        self.gatewayFactory = gatewayFactory
    }
    
    public func makeLoginInteractor(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationLoginInteractor {
        let gateway = gatewayFactory.makeLoginGateway(for: application,
                                                      credentials: credentials)
        
        return ApiApplicationLoginInteractor(gateway: gateway)
    }
    
    public func makeApiKeyInteractor(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationApiKeyInteractor {
        let gateway = gatewayFactory.makeApiKeyGateway(for: application,
                                                       credentials: credentials)
        
        return ApiApplicationApiKeyInteractor(gateway: gateway)
    }
}
