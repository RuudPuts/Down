//
//  DvrShowListGateway.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrShowListGateway: DvrRequestGateway {
    var builder: DvrRequestBuilding
    var executor: RequestExecuting
    var parser: DvrResponseParsing
    
    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }
    
    public func execute() throws -> Observable<[DvrShow]> {
        let request = try builder.make(for: .showList)
        
        return executor.execute(request)
            .map {
                self.parser.parseShows(from: $0)
            }
    }
}
