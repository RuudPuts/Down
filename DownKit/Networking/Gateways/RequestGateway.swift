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

    var executor: RequestExecuting { get }

    func makeRequest() throws -> Request
    func parse(response: Response) -> Result<Element, DownKitError>
    
    func observe() -> Single<Result<Element, DownKitError>>
}

extension RequestGateway {
    public func observe() -> Single<Result<Element, DownKitError>> {
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
