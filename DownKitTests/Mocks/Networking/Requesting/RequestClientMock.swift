//
//  DataTaskExecutingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class RequestClientMock: RequestClient {
    struct Stubs {
        var execute = Execute()
        
        struct Execute {
            var willDo: (Request, ((Request.Response?, RequestClientError?) -> Void)) -> Void = { _, _ in }
        }
    }
    
    var stubs = Stubs()
    
    // RequestClient
    
    func execute(_ request: Request, completion: @escaping (Request.Response?, RequestClientError?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            NSLog("[RequestClientMock] Executing completion stub")
            self.stubs.execute.willDo(request, completion)
        }
    }
}
