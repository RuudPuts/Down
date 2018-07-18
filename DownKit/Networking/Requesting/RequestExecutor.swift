//
//  ApiRequestExecutor.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol RequestExecuting {
    func execute(_ request: Request) -> Observable<Response>
}

public class RequestExecutor: RequestExecuting {
    private let requestClient: RequestClient
    private let disposeBag = DisposeBag()
    
    public init(requestClient: RequestClient = AlamofireRequestClient()) {
        self.requestClient = requestClient
    }
    
    public func execute(_ request: Request) -> Observable<Response> {
        return Observable<Response>.create { observable in
            NSLog("Requesting \(request.url)")
            NSLog("Basic \(request.basicAuthenticationData)")
            NSLog("Form  \(request.formAuthenticationData)")

            self.requestClient.execute(request) {
                guard let response = $0 else {
                    observable.onError($1!)
                    return
                }
                
                observable.onNext(response)
            }
            
            return Disposables.create()
        }
    }
}
