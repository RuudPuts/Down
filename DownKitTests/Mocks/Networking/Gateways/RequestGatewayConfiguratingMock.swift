//
//  RequestGatewayConfiguratingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class RequestGatewayConfiguratingMock: RequestGatewayConfigurating {
    struct Stubs {
        var application: ApiApplication = ApiApplicationMock()
        var requestExecutorFactory: RequestExecutorProducing = RequestExecutorProducingMock()
        var responseMapper: Mapper = ResponseMapperMock<Any>()
    }
    
    var stubs = Stubs()
    
    // RequestGatewayConfigurating
    
    typealias Mapper = ResponseMapperMock<Any>
    
    var application: ApiApplication {
        return stubs.application
    }
    
    var requestExecutorFactory: RequestExecutorProducing {
        return stubs.requestExecutorFactory
    }
    
    var responseMapper: Mapper {
        return stubs.responseMapper
    }
}
