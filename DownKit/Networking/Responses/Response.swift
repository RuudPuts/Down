//
//  Response.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public struct Response: Equatable {
    public var data: Data?
    var statusCode: Int
    var headers: [String: String]?

    init(data: Data?, statusCode: Int, headers: [String: String]?) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }

    init() {
        self.init(data: nil, statusCode: 0, headers: nil)
    }
}

enum StatusCodes: Int {
    case success = 200
    case unauthorized = 401
}
