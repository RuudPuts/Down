//
//  ShowListGateway.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class ShowListGateway: DvrRequestGateway, GetGateway {
    public typealias Config = DvrGatewayConfiguration<DvrShowsResponseMapper>
    
    public var config: Config
    public required init(config: Config) {
        self.config = config
    }
    
    public func get() throws -> Observable<[DvrShow]> {
        let request = try dvrRequestBuilder.make(for: .showList)

        return requestExecutorFactory.make(for: request)
            .execute()
            .map { self.responseMapper.map(storage: $0) }
    }
}
