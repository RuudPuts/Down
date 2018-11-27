//
//  RequestGatewayMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import Result

class RequestGatewayMock: RequestGateway {
    var executor: RequestExecuting = RequestExecutingMock()
    var disposeBag = DisposeBag()

    struct Stubs {
        var request: Request?
        var parse: Any?
        var observe: Any?
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

    func parse(response: Response) -> Result<Any, DownKitError> {
        captures.parse = Captures.Parse(response: response)
        return .success(stubs.parse!)
    }
    
    func observe() -> Single<Result<Any, DownKitError>> {
        return Single.just(.success(stubs.observe!))
    }
}
