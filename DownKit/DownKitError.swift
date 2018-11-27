//
//  DownKitError.swift
//  DownKit
//
//  Created by Ruud Puts on 25/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public enum DownKitError: Error, Hashable {
    case requestExecuting(RequestExecutingError)
    case responseParsing(ResponseParsingError)
}

public enum RequestExecutingError: Error, Hashable {
    case generic(message: String)
    case invalidRequest
    case invalidResponse
    case noData
}

public enum ResponseParsingError: Error, Hashable {
    case noData
    case invalidData
    case invalidJson
    case api(message: String)
    case missingData
}
