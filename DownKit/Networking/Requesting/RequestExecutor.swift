//
//  ApiRequestExecutor.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RxCocoa

//! Currently the only reason of this class's existence is the default param of the init

public protocol RequestExecuting {
    func execute(_ request: Request) -> Observable<Response>
}

public class RequestExecutor: RequestExecuting {
    private let requestClient: RequestClient
    private let disposeBag = DisposeBag()
    
    public init(requestClient: RequestClient = AlamofireRequestClient()) {
        self.requestClient = requestClient
    }
    
    public func execute(_ request: Request) -> Observable<Response> {
        return requestClient.execute(request)
    }
}
