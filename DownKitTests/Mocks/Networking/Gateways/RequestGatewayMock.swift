//
//  RequestGatewayMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class RequestGatewayMock: RequestGateway {
    struct Stubs {
        var config = RequestGatewayConfiguratingMock()
    }
    
    var stubs = Stubs()
    
    // RequestGateway
    
    typealias Config = RequestGatewayConfiguratingMock
    
    var config: RequestGatewayConfiguratingMock {
        get { return stubs.config }
    }
}
