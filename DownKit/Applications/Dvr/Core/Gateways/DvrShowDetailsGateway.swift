//
//  DvrShowDetailsGateway.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrShowDetailsGateway: DvrRequestGateway {
    public var executor: RequestExecuting
    
    var builder: DvrRequestBuilding
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

    public func makeRequest() throws -> Request {
        return try builder.make(for: .showDetails(show))
    }

    public func parse(response: Response) throws -> DvrShow {
        return parser.parseShowDetails(from: response).value!
    }
}
