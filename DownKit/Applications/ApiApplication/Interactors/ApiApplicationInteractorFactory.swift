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

public class ApiApplicationInteractorFactory: ApiApplicationInteractorProducing, Depending {
    public typealias Dependencies = DatabaseDependency & ApiApplicationGatewayFactoryDependency
    public let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func makeLoginInteractor(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationLoginInteractor {
        let gateway = dependencies.apiGatewayFactory.makeLoginGateway(for: application,
                                                                      credentials: credentials)

        return ApiApplicationLoginInteractor(gateway: gateway)
    }

    public func makeApiKeyInteractor(for application: ApiApplication, credentials: UsernamePassword?) -> ApiApplicationApiKeyInteractor {
        let gateway = dependencies.apiGatewayFactory.makeApiKeyGateway(for: application,
                                                                       credentials: credentials)

        return ApiApplicationApiKeyInteractor(gateway: gateway)
    }
}
