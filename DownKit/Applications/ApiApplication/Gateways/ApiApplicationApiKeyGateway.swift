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
    
    var builder: ApiApplicationRequestBuilding
    var parser: ApiApplicationResponseParsing
    var credentials: UsernamePassword?

    public required init(builder: ApiApplicationRequestBuilding, parser: ApiApplicationResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public convenience init(builder: ApiApplicationRequestBuilding,
                            parser: ApiApplicationResponseParsing,
                            executor: RequestExecuting = RequestExecutor(),
                            credentials: UsernamePassword? = nil) {
        self.init(builder: builder, parser: parser, executor: executor)
        self.credentials = credentials
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .apiKey, credentials: credentials)
    }

    public func parse(response: Response) throws -> String? {
        return parser.parseApiKey(from: response).value!
    }
}
