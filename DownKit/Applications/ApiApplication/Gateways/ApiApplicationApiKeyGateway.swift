//
//  ApiApplicationApiKeyGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class ApiApplicationApiKeyGateway: ApiApplicationRequestGateway {
    public var executor: RequestExecuting
    public var disposeBag = DisposeBag()
    
    var builder: ApiApplicationRequestBuilding
    var parser: ApiApplicationResponseParsing

    public required init(builder: ApiApplicationRequestBuilding, parser: ApiApplicationResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .apiKey)
    }

    public func parse(response: Response) throws -> String? {
        return try parser.parseApiKey(from: response)
    }
}
