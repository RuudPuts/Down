//
//  ApiApplicationGatewayFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ApiApplicationGatewayProducing {
    func makeLoginGateway(for application: ApiApplication) -> ApiApplicationLoginGateway
    func makeApiKeyGateway(for application: ApiApplication) -> ApiApplicationApiKeyGateway
}

public class ApiApplicationGatewayFactory: ApiApplicationGatewayProducing {
    var additionsFactory: ApplicationAdditionsProducing
    
    public init(additionsFactory: ApplicationAdditionsProducing = ApplicationAdditionsFactory()) {
        self.additionsFactory = additionsFactory
    }
    
    public func makeLoginGateway(for application: ApiApplication) -> ApiApplicationLoginGateway {
        return ApiApplicationLoginGateway(builder: additionsFactory.makeApiApplicationRequestBuilder(for: application),
                                          parser: additionsFactory.makeApiApplicationResponseParser(for: application))
    }
    
    public func makeApiKeyGateway(for application: ApiApplication) -> ApiApplicationApiKeyGateway {
        return ApiApplicationApiKeyGateway(builder: additionsFactory.makeApiApplicationRequestBuilder(for: application),
                                           parser: additionsFactory.makeApiApplicationResponseParser(for: application))
    }
}
