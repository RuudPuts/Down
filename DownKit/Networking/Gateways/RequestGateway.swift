//
//  RequestGateway.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result

public protocol RequestGateway {
    associatedtype ResultType

    var executor: RequestExecuting { get }

    func makeRequest() throws -> Request
    func parse(response: Response) throws -> ResultType
    
    func observe() -> Single<ResultType>
}

extension RequestGateway {
    public func observe() -> Single<ResultType> {
        var request: Request
        do {
            request = try self.makeRequest()
        }
        catch {
            return Single.error(error)
        }

        return self.executor
                .execute(request)
                .map { result in
                    let parsed = try self.parse(response: result.value!)

                    return parsed
                }
    }
}
