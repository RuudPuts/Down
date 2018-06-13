//
//  DvrGatewayConfiguration.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

struct DvrGatewayConfiguration<Mapper: ResponseMapper>: RequestGatewayConfigurating {
    var application: ApiApplication
    var requestExecutorFactory: RequestExecutorProducing
    var responseMapper: Mapper
    
    init(application: ApiApplication,
         responseMapper: Mapper,
         requestExecutorFactory: RequestExecutorProducing = RequestExecutorFactory()) {
        self.application = application
        self.requestExecutorFactory = requestExecutorFactory
        self.responseMapper = responseMapper
    }
}
