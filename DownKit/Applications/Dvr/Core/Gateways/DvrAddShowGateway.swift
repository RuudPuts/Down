//
//  DvrAddShowGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrAddShowGateway: DvrRequestGateway {
    public var executor: RequestExecuting

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    var show: DvrShow!
    var status: DvrEpisodeStatus!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public convenience init(show: DvrShow, status: DvrEpisodeStatus = .skipped, builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.init(builder: builder, parser: parser, executor: executor)
        self.show = show
        self.status = status
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .addShow(show, status))
    }

    public func parse(response: Response) throws -> Bool {
        return try parser.parseAddShow(from: response)
    }
}
