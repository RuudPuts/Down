//
//  RequestGateway.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol RequestGateway {
    associatedtype ResultType

    var executor: RequestExecuting { get }
    var disposeBag: DisposeBag { get }

    func makeRequest() throws -> Request
    func parse(response: Response) throws -> ResultType
    
    func observe() -> Observable<ResultType>
}

extension RequestGateway {
    public func observe() -> Observable<ResultType> {
        return Observable.create { observer in
            let request: Request
            do {
                request = try self.makeRequest()
            }
            catch {
                observer.onError(error)
                return Disposables.create()
            }

            self.executor
                .execute(request)
                .subscribe(onNext: {
                    do {
                        observer.onNext(try self.parse(response: $0))
                    }
                    catch {
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}
