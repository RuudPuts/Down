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
        var execute = Observable<Response>.just(
            Response(data: nil, statusCode: 0, headers: [:])
        )
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
    
    func execute(_ request: Request) -> Observable<Response> {
        captures.execute = Captures.Execute(request: request)
        return stubs.execute
    }
}
