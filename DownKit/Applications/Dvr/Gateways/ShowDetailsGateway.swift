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
        let request = try dvrRequestBuilder.make(for: .showDetails(show))

        return requestExecutorFactory.make(for: request)
            .execute()
            .map { self.responseMapper.map(storage: $0) }
    }
}
