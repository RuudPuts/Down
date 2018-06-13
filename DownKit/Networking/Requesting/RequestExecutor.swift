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
    let bag = DisposeBag()
    
    enum ExecutionError: Error {
        case invalidRequest
        case invalidResponse
        case noData
        case generic(message: String)
    }
    
    init(request: Request) {
        self.request = request
    }
    
    func execute() -> Observable<Request.Response> {
        print("Requesting: \(self.request.url)")
        
        return Observable<Request.Response>.create { observer -> Disposable in
            guard let request = self.request.asUrlRequest() else {
                observer.onError(ExecutionError.invalidRequest)
                return Disposables.create()
            }
            
            self.execute(request, withObserver: observer)
            
            return Disposables.create()
        }
    }
}

typealias RequestExecutorInternals = RequestExecutor
extension RequestExecutorInternals {
    private func execute(_ request: URLRequest, withObserver observer: AnyObserver<Request.Response>) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                observer.onError(ExecutionError.generic(message: error!.localizedDescription))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                observer.onError(ExecutionError.invalidResponse)
                return
            }
            
            guard let data = data else {
                observer.onError(ExecutionError.noData)
                return
            }
            
            observer.onNext(Request.Response(data: data, statusCode: httpResponse.statusCode, headers: httpResponse.allHeaderFields))
            }.resume()
    }
}
