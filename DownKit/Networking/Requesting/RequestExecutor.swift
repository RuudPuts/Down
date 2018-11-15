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
    func execute(_ request: Request) -> Single<Response>
}

public class RequestExecutor: RequestExecuting {
    private let requestClient: RequestClient
    
    public init(requestClient: RequestClient = AlamofireRequestClient()) {
        self.requestClient = requestClient
    }
    
    public func execute(_ request: Request) -> Single<Response> {
        return requestClient.execute(request)
    }
}
