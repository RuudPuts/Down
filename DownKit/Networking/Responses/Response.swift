//
//  Response.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class Response {
    public var data: Data?
    let statusCode: Int
    let headers: [String: String]?

    init(data: Data?, statusCode: Int, headers: [String: String]?) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }
}

extension Response: Equatable {
    public static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.data == rhs.data
            && lhs.statusCode == rhs.statusCode
            && lhs.headers == rhs.headers
    }
}

enum StatusCodes: Int {
    case success = 200
    case unauthorized = 401
}
