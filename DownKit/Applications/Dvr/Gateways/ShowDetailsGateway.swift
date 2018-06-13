//
//  ShowDetailsGateway.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class ShowDetailsGateway: DvrRequestGateway, GetGateway {
    public typealias Config = DvrGatewayConfiguration<DvrShowDetailsResponseMapper>
    
    public var config: Config
    var show: DvrShow
    
    public init(config: Config, show: DvrShow) {
        self.config = config
        self.show = show
    }
    
    public func get() throws -> Observable<DvrShow> {
        guard let request = dvrRequestBuilder.make(for: DvrApplicationCall.showDetails(show)) else {
            throw RequestPreparationError.notSupportedError("List call not supported by \(application.name)")
        }

        return config
            .requestExecutorFactory.make(for: request)
            .execute()
            .do(onError: { error in
                print("Error: \(error)")
            })
            .map { self.responseMapper.map(storage: $0) }
    }
}
