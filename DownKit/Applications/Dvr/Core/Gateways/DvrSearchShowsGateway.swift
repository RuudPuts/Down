//
//  DvrSearchShowsGateway.swift
//  Down
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrSearchShowsGateway: DvrRequestGateway {
    var builder: DvrRequestBuilding
    var executor: RequestExecuting
    var parser: DvrResponseParsing

    var query: String!
    
    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }
    
    public func observe() throws -> Observable<[DvrShow]> {
        let request = try builder.make(for: .searchShows(query))
        
        return executor.execute(request)
            .map { try self.parser.parseSearchShows(from: $0) }
    }
}
