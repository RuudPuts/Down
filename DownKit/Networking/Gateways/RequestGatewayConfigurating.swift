//
//  RequestGatewayConfigurating.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol RequestGatewayConfigurating {
    associatedtype Mapper: ResponseMapper
    
    var application: ApiApplication { get }
    var requestExecutorFactory: RequestExecutorProducing { get }
    var responseMapper: Mapper { get }
}
