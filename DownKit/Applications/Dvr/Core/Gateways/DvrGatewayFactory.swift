//
//  DvrGatewayFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrGatewayProducing {
    func makeShowListGateway(for application: DvrApplication) -> DvrShowListGateway
    func makeShowDetailsGateway(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsGateway
    func makeSearchShowsGateway(for application: DvrApplication, query: String) -> DvrSearchShowsGateway
    func makeAddShowGateway(for application: DvrApplication, show: DvrShow) -> DvrAddShowGateway
}

public class DvrGatewayFactory: DvrGatewayProducing, Depending {
    public typealias Dependencies = ApplicationAdditionsFactoryDependency
    public let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeShowListGateway(for application: DvrApplication) -> DvrShowListGateway {
        return DvrShowListGateway(builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                  parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }
    
    public func makeShowDetailsGateway(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsGateway {
        return DvrShowDetailsGateway(show: show,
                                     builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                     parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeSearchShowsGateway(for application: DvrApplication, query: String) -> DvrSearchShowsGateway {
        return DvrSearchShowsGateway(query: query,
                                     builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                     parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeAddShowGateway(for application: DvrApplication, show: DvrShow) -> DvrAddShowGateway {
        return DvrAddShowGateway(show: show,
                                 builder: dependencies.applicationAdditionsFactory.makeDvrRequestBuilder(for: application),
                                 parser: dependencies.applicationAdditionsFactory.makeDvrResponseParser(for: application))
    }
}
