//
//  DvrFetchEpisodeDetailsGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrFetchEpisodeDetailsGateway: DvrRequestGateway {
    public var executor: RequestExecuting

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    var episode: DvrEpisode!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    convenience init(episode: DvrEpisode, builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.init(builder: builder, parser: parser, executor: executor)

        self.episode = episode
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .fetchEpisodeDetails(episode))
    }

    public func parse(response: Response) throws -> DvrEpisode {
        return try parser.parseEpisodeDetails(for: episode, from: response)
    }
}
