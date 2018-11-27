//
//  DownloadDeleteItemGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 20/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result

public class DownloadDeleteItemGateway: DownloadRequestGateway {
    public var executor: RequestExecuting

    var builder: DownloadRequestBuilding
    var parser: DownloadResponseParsing
    var item: DownloadItem!

    public required init(builder: DownloadRequestBuilding, parser: DownloadResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    convenience init(builder: DownloadRequestBuilding, parser: DownloadResponseParsing, executor: RequestExecuting = RequestExecutor(), item: DownloadItem) {
        self.init(builder: builder, parser: parser, executor: executor)
        self.item = item
    }

    public func makeRequest() throws -> Request {
        return try builder.make(for: .delete(item: item))
    }

    public func parse(response: Response) -> Result<Bool, DownKitError> {
        return parser.parseDeleteItem(from: response)
    }
}
