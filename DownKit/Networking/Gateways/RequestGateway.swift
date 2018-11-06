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

    func makeRequest() throws -> Request
    func parse(response: Response) throws -> ResultType
    
    func observe() -> Observable<ResultType>
}

extension RequestGateway {
    public func observe() -> Observable<ResultType> {
        let request: Request
        do {
            request = try self.makeRequest()
        }
        catch {
            return Observable.create {
                $0.onError(error)

                return Disposables.create()
            }
        }

        return self.executor
                .execute(request)
                .map { try self.parse(response: $0) }
    }
}
