//
//  Response.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class Response: Equatable {
    let request: Request
    public var data: Data?
    let statusCode: Int
    let headers: [String: String]?

    init(request: Request, data: Data?, statusCode: Int, headers: [String: String]?) {
        self.request = request
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }
}

enum StatusCodes: Int {
    case success = 200
    case unauthorized = 401
}
