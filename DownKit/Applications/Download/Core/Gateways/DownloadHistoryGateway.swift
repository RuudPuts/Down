//
//  DownloadHistoryGateway.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DownloadHistoryGateway: DownloadRequestGateway {
    public var executor: RequestExecuting

    var builder: DownloadRequestBuilding
    var parser: DownloadResponseParsing
    
    public required init(builder: DownloadRequestBuilding, parser: DownloadResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .history)
    }

    public func parse(response: Response) throws -> [DownloadItem] {
        return parser.parseHistory(from: response).value!
    }
}
