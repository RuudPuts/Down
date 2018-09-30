//
//  DvrFetchPosterGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 26/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrFetchPosterGateway: DvrRequestGateway {
    public var executor: RequestExecuting
    public var disposeBag = DisposeBag()

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    var show: DvrShow!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .fetchPoster(show))
    }

    public func parse(response: Response) throws -> UIImage {
        return try parser.parseImage(from: response)
    }
}
