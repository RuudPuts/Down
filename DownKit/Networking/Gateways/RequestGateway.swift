//
//  RequestGateway.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

enum RequestPreparationError: Error {
    case notSupportedError(String)
}

public protocol RequestGateway {
    associatedtype Config: RequestGatewayConfigurating
    
    var config: Config { get }
}

extension RequestGateway {
    var application: ApiApplication {
        return config.application
    }
    
    var requestBuilder: RequestBuilding {
        return application.requestBuilder
    }
    
    var requestExecutorFactory: RequestExecutorProducing {
        return config.requestExecutorFactory
    }
    
    var responseMapper: Config.Mapper {
        return config.responseMapper
    }
}

public protocol GetGateway {
    associatedtype ResultType
    func get() throws -> Observable<ResultType>
}

public protocol PostGateway {
    associatedtype ResultType
    func post() throws -> Observable<ResultType>
}

public protocol PutGateway {
    associatedtype ResultType
    func put() throws -> Observable<ResultType>
}

public protocol DeleteGateway {
    associatedtype ResultType
    func delete() throws -> Observable<ResultType>
}
