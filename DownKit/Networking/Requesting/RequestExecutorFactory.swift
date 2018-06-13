//
//  RequestExecutorFactory.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol RequestExecutorProducing {
    func make(for: Request) -> RequestExecuting
}

class RequestExecutorFactory: RequestExecutorProducing {
    func make(for request: Request) -> RequestExecuting {
        return RequestExecutor(request: request)
    }
}
