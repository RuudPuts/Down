//
//  DvrSetEpisodeStatusGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result

public class DvrSetEpisodeStatusGateway: DvrRequestGateway {
    public var executor: RequestExecuting

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    var episode: DvrEpisode!
    var status: DvrEpisodeStatus!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    convenience init(episode: DvrEpisode, status: DvrEpisodeStatus, builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.init(builder: builder, parser: parser, executor: executor)

        self.episode = episode
        self.status = status
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .setEpisodeStatus(episode, status))
    }

    public func parse(response: Response) -> Result<Bool, DownKitError> {
        return parser.parseSetEpisodeStatus(from: response)
    }
}
