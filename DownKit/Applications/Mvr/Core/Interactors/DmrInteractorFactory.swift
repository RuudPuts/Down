//
//  DmrInteractorFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 04/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DmrInteractorProducing {
}

public class DmrInteractorFactory: DmrInteractorProducing, Depending {
    public typealias Dependencies = DatabaseDependency & DmrGatewayFactoryDependency
    public let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
