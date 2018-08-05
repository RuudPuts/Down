//
//  DvrDeleteShowInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrDeleteShowInteractor: RequestGatewayInteracting {
    public typealias Gateway = DvrDeleteShowGateway
    public typealias Element = Gateway.ResultType
    public var gateway: Gateway

    var subject: Variable<Bool> = Variable(false)

    var database: DvrDatabase!
    let disposeBag = DisposeBag()

    public required init(gateway: Gateway) {
        self.gateway = gateway
    }
    
    convenience init(gateway: Gateway, database: DvrDatabase) {
        self.init(gateway: gateway)
        self.database = database
    }
    
    public func observe() -> Observable<Bool> {
        return gateway.observe()
            .do(onNext: {
                guard $0 else { return }

                self.database.delete(show: self.gateway.show)
            })
    }
}
