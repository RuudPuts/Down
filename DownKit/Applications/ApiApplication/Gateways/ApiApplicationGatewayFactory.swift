//
//  ApiApplicationGatewayFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ApiApplicationGatewayProducing {
    func makeLoginGateway(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationLoginGateway
    func makeApiKeyGateway(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationApiKeyGateway
}

public class ApiApplicationGatewayFactory: ApiApplicationGatewayProducing, Depending {
    public typealias Dependencies = ApplicationAdditionsFactoryDependency
    public let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeLoginGateway(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationLoginGateway {
        return ApiApplicationLoginGateway(builder: dependencies.applicationAdditionsFactory.makeApiApplicationRequestBuilder(for: application),
                                          parser: dependencies.applicationAdditionsFactory.makeApiApplicationResponseParser(for: application),
                                          credentials: credentials)
    }
    
    public func makeApiKeyGateway(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationApiKeyGateway {
        return ApiApplicationApiKeyGateway(builder: dependencies.applicationAdditionsFactory.makeApiApplicationRequestBuilder(for: application),
                                           parser: dependencies.applicationAdditionsFactory.makeApiApplicationResponseParser(for: application),
                                           credentials: credentials)
    }
}
