//
//  DvrShowDetailsGateway.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrShowDetailsGateway: DvrRequestGateway {
    var builder: DvrRequestBuilding
    var executor: RequestExecuting
    var parser: DvrResponseParsing
    var show: DvrShow!
    
    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }
    
    convenience init(show: DvrShow, builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.init(builder: builder, parser: parser, executor: executor)
        self.show = show
    }
    
    public func execute() throws -> Observable<DvrShow> {
        let request = try builder.make(for: .showDetails(show))
        
        return executor.execute(request)
            .map { self.parser.parseShowDetails(from: $0) }
    }
}
