//
//  DownloadResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownloadResponseParsing: ResponseParsing {
    func parseQueue(from response: Response) throws -> DownloadQueue
    func parseHistory(from response: Response) throws -> [DownloadItem]
}
