//
//  RequestClient.swift
//  DownKit
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol RequestClient {
    func execute(_ request: Request) -> Single<Response>
}

public enum RequestClientError: Error, Hashable {
    case generic(message: String)
    case invalidRequest
    case invalidResponse
    case noData
}
