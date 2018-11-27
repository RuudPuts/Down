//
//  DataTaskExecutingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift

class RequestClientMock: RequestClient {
    struct Stubs {
        var execute = Execute()
        
        struct Execute {
            var response: Response?
            var error: DownKitError?
        }
    }
    
    var stubs = Stubs()
    
    // RequestClient

    func execute(_ request: Request) -> RequestExecutionResult {
        return RequestExecutionResult.create { observer in
            if let error = self.stubs.execute.error {
                observer(.success(.failure(error)))
            }
            else if let response = self.stubs.execute.response {
                observer(.success(.success(response)))
            }
            else {
                fatalError("RequestClientMock executed without stubs")
            }

            return Disposables.create()
        }
    }
}
