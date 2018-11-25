//
//  DvrSearchShowsGateway.swift
//  Down
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrSearchShowsGateway: DvrRequestGateway {
    public var executor: RequestExecuting

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    var query: String!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public convenience init(query: String, builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.init(builder: builder, parser: parser, executor: executor)
        self.query = query
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .searchShows(query))
    }

    public func parse(response: Response) throws -> [DvrShow] {
        return parser.parseSearchShows(from: response).value!
    }
}
