//
//  DvrDeleteShowGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrDeleteShowGateway: DvrRequestGateway {
    var builder: DvrRequestBuilding
    var executor: RequestExecuting
    var parser: DvrResponseParsing

    var show: DvrShow!
    var status: DvrEpisode.Status!

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func observe() throws -> Observable<Bool> {
        let request = try builder.make(for: .deleteShow(show))

        return executor.execute(request)
            .map { try self.parser.parseDeleteShow(from: $0) }
    }
}
