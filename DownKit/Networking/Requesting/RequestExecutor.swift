//
//  ApiRequestExecutor.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RxCocoa
import Result

public protocol RequestExecuting {
    typealias RequestExecutionResult = Single<Result<Response, RequestExecutorError>>

    func execute(_ request: Request) -> RequestExecutionResult
}

public enum RequestExecutorError: Error, Hashable {
    case generic(message: String)
    case invalidRequest
    case invalidResponse
    case noData
}

public class RequestExecutor: RequestExecuting {
    private let requestClient: RequestClient
    
    public init(requestClient: RequestClient = AlamofireRequestClient()) {
        self.requestClient = requestClient
    }
    
    public func execute(_ request: Request) -> RequestExecutionResult {
        return requestClient.execute(request)
    }
}
