//
//  RequestExecutingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import Result

class RequestExecutingMock: RequestExecuting {
    struct Stubs {
        var request = Request.defaultStub
        var execute: Result<Response, DownKitError> = .success(Response.defaultStub)
    }
    
    struct Captures {
        var execute: Execute?
        
        struct Execute {
            let request: Request
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // RequestExecuting

    func execute(_ request: Request) -> RequestExecutionResult {
        captures.execute = Captures.Execute(request: request)
        return Single.just(stubs.execute)
    }
}
