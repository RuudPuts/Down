//
//  DvrSetEpisodeStatusGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrSetEpisodeStatusGateway: DvrRequestGateway {
    public var executor: RequestExecuting
    public var disposeBag = DisposeBag()

    var builder: DvrRequestBuilding
    var parser: DvrResponseParsing

    var episode: DvrEpisode!
    var status: DvrEpisodeStatus!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .setEpisodeStatus(episode, status))
    }

    public func parse(response: Response) throws -> Bool {
        return try parser.parseSetEpisodeStatus(from: response)
    }
}
