//
//  ShowListGateway.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

class ShowListGateway: DvrRequestGateway, GetGateway {
    typealias Config = DvrGatewayConfiguration<DvrShowsResponseMapper>
    
    var config: Config
    init(config: Config) {
        self.config = config
    }
    
    func get() throws -> Observable<[DvrShow]> {
        guard let request = dvrRequestBuilder.make(for: DvrApplicationCall.showList) else {
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
