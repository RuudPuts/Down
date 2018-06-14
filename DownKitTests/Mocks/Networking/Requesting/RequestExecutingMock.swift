//
//  RequestExecutingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift

class RequestExecutingMock: RequestExecuting {
    struct Stubs {
        var request = Request(url: "", method: .get, parameters: nil)
        var execute = Observable<Request.Response>.just(
            Request.Response(data: nil, statusCode: 0, headers: [:])
        )
    }
    
    struct Captures {
        var request: Request?
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // RequestExecuting
    
    var request: Request {
        get { return stubs.request }
        set { captures.request = newValue }
    }
    
    func execute() -> Observable<Request.Response> {
        return stubs.execute
    }
}
