//
//  DvrSetSeasonStatusGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrSetSeasonStatusGateway: DvrRequestGateway {
    public var executor: RequestExecuting
    public var disposeBag = DisposeBag()

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    var season: DvrSeason!
    var status: DvrEpisodeStatus!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .setSeasonStatus(season, status))
    }

    public func parse(response: Response) throws -> Bool {
        return try parser.parseSetSeasonStatus(from: response)
    }
}
