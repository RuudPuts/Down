//
//  RequestClient.swift
//  DownKit
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

//! Should use onError of RX

public protocol RequestClient {
    func execute(_ request: Request, completion: @escaping (Response?, RequestClientError?) -> Void)
}

public enum RequestClientError: Error, Hashable {
    case generic(message: String)
    case invalidRequest
    case invalidResponse
    case noData
}
