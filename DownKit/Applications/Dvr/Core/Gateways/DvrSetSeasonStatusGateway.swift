//
//  DvrSetSeasonStatusGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result

public class DvrSetSeasonStatusGateway: DvrRequestGateway {
    public var executor: RequestExecuting

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    var season: DvrSeason!
    var status: DvrEpisodeStatus!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    convenience init(season: DvrSeason, status: DvrEpisodeStatus, builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.init(builder: builder, parser: parser, executor: executor)

        self.season = season
        self.status = status
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .setSeasonStatus(season, status))
    }

    public func parse(response: Response) -> Result<Bool, DownKitError> {
        return parser.parseSetSeasonStatus(from: response)
    }
}
