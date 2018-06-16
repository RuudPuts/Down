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
    var request: Request { get }
    
    func execute() -> Observable<Request.Response>
}

class RequestExecutor: RequestExecuting {
    var request: Request
    
    private let requestClient: RequestClient
    private let disposeBag = DisposeBag()
    
    init(request: Request, requestClient: RequestClient = URLSession.shared) {
        self.request = request
        self.requestClient = requestClient
    }
    
    func execute() -> Observable<Request.Response> {
        return Observable<Request.Response>.create { observable in
            self.requestClient.execute(self.request) {
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
