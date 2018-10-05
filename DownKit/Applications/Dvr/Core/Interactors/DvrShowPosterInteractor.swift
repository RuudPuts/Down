//
//  DvrShowPosterInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RxSwiftExt

public class DvrShowPosterInteractor: RequestGatewayInteracting {
    public typealias Gateway = DvrFetchPosterGateway
    public typealias Element = Gateway.ResultType
    public var gateway: Gateway
    var show: DvrShow!

    public required init(gateway: Gateway) {
        self.gateway = gateway
    }

    convenience init(gateway: Gateway, show: DvrShow) {
        self.init(gateway: gateway)
        self.show = show
    }
    
    public func observe() -> Observable<UIImage> {
        if let image = DvrAssetStorage.poster(for: show) {
            return Observable.just(image)
        }

        gateway.show = show

        return gateway
            .observe()
            .do(onNext: {
                let poster = $0.scaled(to: CGSize(width: 200, height: 300))
                DvrAssetStorage.store(poster: poster, for: self.show)
            })
    }
}
