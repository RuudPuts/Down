//
//  ApiApplicationApiKeyGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class ApiApplicationApiKeyGateway: ApiApplicationRequestGateway {
    var builder: ApiApplicationRequestBuilding
    var executor: RequestExecuting
    var parser: ApiApplicationResponseParsing

    public required init(builder: ApiApplicationRequestBuilding, parser: ApiApplicationResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func execute() throws -> Observable<String?> {
        let request = try builder.make(for: .apiKey, credentials: nil)

        return executor.execute(request)
            .map { try self.parser.parseApiKey(from: $0) }
    }
}
