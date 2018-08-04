//
//  DvrSetEpisodeStatusGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrSetEpisodeStatusGateway: DvrRequestGateway {
    var builder: DvrRequestBuilding
    var executor: RequestExecuting
    var parser: DvrResponseParsing

    var episode: DvrEpisode!
    var status: DvrEpisode.Status!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func observe() throws -> Observable<Bool> {
        let request = try builder.make(for: .setEpisodeStatus(episode, status))

        return executor.execute(request)
            .map { try self.parser.parseSetEpisodeStatus(from: $0) }
    }
}
