//
//  DvrGatewayConfiguration.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public struct DvrGatewayConfiguration<Mapper: ResponseMapper>: RequestGatewayConfigurating {
    public var application: ApiApplication
    public var responseMapper: Mapper
    public var requestExecutorFactory: RequestExecutorProducing
    
    init(application: ApiApplication,
         responseMapper: Mapper,
         requestExecutorFactory: RequestExecutorProducing = RequestExecutorFactory()) {
        self.application = application
        self.requestExecutorFactory = requestExecutorFactory
        self.responseMapper = responseMapper
    }
}
