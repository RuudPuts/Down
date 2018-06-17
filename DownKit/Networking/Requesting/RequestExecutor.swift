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
    func execute(_ request: Request) -> Observable<Request.Response>
}

public class RequestExecutor: RequestExecuting {
    private let requestClient: RequestClient
    private let disposeBag = DisposeBag()
    
    public init(requestClient: RequestClient = URLSession.shared) {
        self.requestClient = requestClient
    }
    
    public func execute(_ request: Request) -> Observable<Request.Response> {
        return Observable<Request.Response>.create { observable in
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
