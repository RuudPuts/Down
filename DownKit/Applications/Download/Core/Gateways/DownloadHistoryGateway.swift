//
//  DownloadHistoryGateway.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DownloadHistoryGateway: DownloadRequestGateway {
    var builder: DownloadRequestBuilding
    var executor: RequestExecuting
    var parser: DownloadResponseParsing
    
    public required init(builder: DownloadRequestBuilding, parser: DownloadResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }
    
    public func execute() throws -> Observable<[DownloadItem]> {
        let request = try builder.make(for: .history)
        
        return executor.execute(request)
            .map { try self.parser.parseHistory(from: $0) }
    }
}
