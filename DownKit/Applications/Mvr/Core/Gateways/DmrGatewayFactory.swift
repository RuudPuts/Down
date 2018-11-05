//
//  DmrGatewayFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 05/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DmrGatewayProducing {
}

public class DmrGatewayFactory: DmrGatewayProducing, Depending {
    public typealias Dependencies = ApplicationAdditionsFactoryDependency
    public let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
