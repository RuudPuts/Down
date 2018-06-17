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
        var execute: Observable<Any> = Observable.just(0)
    }
    
    var stubs = Stubs()
    
    // RequestGateway
    
    func execute() throws -> Observable<Any> {
        return stubs.execute
    }
}
