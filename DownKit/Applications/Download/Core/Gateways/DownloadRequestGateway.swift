//
//  DownloadRequestGateway.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol DownloadRequestGateway: RequestGateway {
    var builder: DownloadRequestBuilding { get }
    var executor: RequestExecuting { get }
    var parser: DownloadResponseParsing { get }
    
    init(builder: DownloadRequestBuilding, parser: DownloadResponseParsing, executor: RequestExecuting)
}
