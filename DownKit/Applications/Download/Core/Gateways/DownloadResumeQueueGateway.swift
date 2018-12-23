//
//  DownloadResumeQueueGateway.swift
//  Down
//
//  Created by Ruud Puts on 23/12/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DownloadResumeQueueGateway: DownloadRequestGateway {
    public var executor: RequestExecuting

    var builder: DownloadRequestBuilding
    var parser: DownloadResponseParsing

    public required init(builder: DownloadRequestBuilding, parser: DownloadResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .resumeQueue)
    }

    public func parse(response: Response) throws -> Bool {
        return try parser.parseSuccess(from: response)
    }
}
