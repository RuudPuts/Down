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
            var error: Error?
        }
    }
    
    var stubs = Stubs()
    
    // RequestClient

    func execute(_ request: Request) -> Observable<Response> {
        return Observable<Response>.create { observer in
            if let error = self.stubs.execute.error {
                observer.onError(error)
            }
            else if let response = self.stubs.execute.response {
                observer.onNext(response)
            }
            else {
                NSLog("!!! RequestClientMock executed without stubs")
            }

            return Disposables.create()
        }
    }
}
