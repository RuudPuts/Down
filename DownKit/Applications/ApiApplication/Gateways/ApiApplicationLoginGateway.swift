//
//  ApiApplicationLoginGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class ApiApplicationLoginGateway: ApiApplicationRequestGateway {
    var builder: ApiApplicationRequestBuilding
    var executor: RequestExecuting
    var parser: ApiApplicationResponseParsing
    var credentials: UsernamePassword?

    public required init(builder: ApiApplicationRequestBuilding,
                         parser: ApiApplicationResponseParsing,
                         executor: RequestExecuting = RequestExecutor()) {
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

    public func execute() throws -> Observable<LoginResult> {
        let request = try builder.make(for: .login, credentials: credentials)

        return executor.execute(request)
            .map {
                do {
                    return try self.parser.parseLoggedIn(from: $0)
                }
                catch {
                    return .failed
                }
            }
    }
}

public enum LoginResult {
    case failed
    case authenticationRequired
    case success
}
