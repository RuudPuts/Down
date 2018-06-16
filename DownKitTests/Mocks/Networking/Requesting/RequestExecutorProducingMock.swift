//
//  RequestExecutorProducingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class RequestExecutorProducingMock: RequestExecutorProducing {
    struct Stubs {
        var make: RequestExecuting = RequestExecutingMock()
    }
    
    struct Captures {
        var make: Make?
        
        struct Make {
            var request: Request
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // RequestExecutorProducing
    
    func make(for request: Request) -> RequestExecuting {
        captures.make = Captures.Make(request: request)
        return stubs.make
    }
}
