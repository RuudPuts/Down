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
    typealias RequestExecutionResult = Single<Result<Response, DownKitError>>

    func execute(_ request: Request) -> RequestExecutionResult
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
