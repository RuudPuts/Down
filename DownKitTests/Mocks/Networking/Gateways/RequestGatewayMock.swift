//
//  RequestGatewayMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift

class RequestGatewayMock: RequestGateway {    
    struct Stubs {
        var config = RequestGatewayConfiguratingMock()
        var execute: Observable<Any> = Observable.just(0)
    }
    
    var stubs = Stubs()
    
    // RequestGateway
    
    typealias Config = RequestGatewayConfiguratingMock
    
    var config: RequestGatewayConfiguratingMock { return stubs.config }
    
    func execute() throws -> Observable<Any> {
        return stubs.execute
    }
}
