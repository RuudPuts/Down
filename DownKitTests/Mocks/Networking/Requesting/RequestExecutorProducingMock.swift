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
    
    var stubs = Stubs()
    
    // RequestExecutorProducing
    
    func make(for: Request) -> RequestExecuting {
        return stubs.make
    }
}
