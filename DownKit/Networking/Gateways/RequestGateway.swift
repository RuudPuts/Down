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
    associatedtype Element
    typealias ResultType = Result<Element, DownKitError>

    var executor: RequestExecuting { get }

    func makeRequest() throws -> Request
    func parse(response: Response) -> ResultType

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
            .map {
                $0.flatMap {
                    self.parse(response: $0)
                }
            }
    }
}
