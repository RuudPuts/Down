//
//  DvrGatewayConfigurationFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 13/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol DvrGatewayProducing {
    var application: DvrApplication { get }
    init(application: DvrApplication)
    
    func make<Mapper: DvrResponseMapper>() -> DvrGatewayConfiguration<Mapper>
}

class DvrGatewayConfigurationFactory: DvrGatewayProducing {
    var application: DvrApplication
    
    required init(application: DvrApplication) {
        self.application = application
    }
    
    func make<Mapper: DvrResponseMapper>() -> DvrGatewayConfiguration<Mapper> {
        return DvrGatewayConfiguration<Mapper>(
            application: application,
            responseMapper: Mapper(parser: application.responseParser)
        )
    }
}
