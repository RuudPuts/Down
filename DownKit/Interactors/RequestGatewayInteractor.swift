//
//  RequestGatewayInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol RequestGatewayInteractor: ObservableInteractor where Element == Gateway.ResultType {
    associatedtype Gateway: RequestGateway
    
    var gateway: Gateway { get }
    init(gateway: Gateway)
    
    func execute() -> Observable<Gateway.ResultType>
}

extension RequestGatewayInteractor {
    public func execute() -> Observable<Gateway.ResultType> {
        // swiftlint:disable force_try
        return try! gateway.execute()
    }
}
