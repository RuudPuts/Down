//
//  DvrShowListGateway.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrShowListGateway: DvrRequestGateway {
    public var executor: RequestExecuting
    public var disposeBag = DisposeBag()

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .showList)
    }

    public func parse(response: Response) throws -> [DvrShow] {
        return try parser.parseShows(from: response)
    }
}
