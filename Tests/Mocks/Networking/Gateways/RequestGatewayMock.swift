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
    var executor: RequestExecuting = RequestExecutingMock()
    var disposeBag: DisposeBag = DisposeBag()

    struct Stubs {
        var request: Request?
        var parse: Any?
        var observe: Observable<Any> = Observable.just(0)
    }

    struct Captures {
        var parse: Parse?

        struct Parse {
            let response: Response
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // RequestGateway

    func makeRequest() throws -> Request {
        return stubs.request!
    }

    func parse(response: Response) throws -> Any {
        captures.parse = Captures.Parse(response: response)
        return stubs.parse!
    }
    
    func observe() -> Observable<Any> {
        return stubs.observe
    }
}
