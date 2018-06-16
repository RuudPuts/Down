//
//  Reqeust.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public class Request {
    var method: Method
    var url: String

    public enum Method: String {
        case get
        case post
        case put
        case delete
    }
    
    //! Move to Response.swift
    public class Response: DataStoring {
        public var data: Data?
        var statusCode: Int
        var headers: [String: String]?
        
        init(data: Data?, statusCode: Int, headers: [String: String]?) {
            self.data = data
            self.statusCode = statusCode
            self.headers = headers
        }
    }
    
    init(url: String, method: Method, parameters: [String: String]?) {
        self.url = url.inject(parameters: parameters)
        self.method = method
    }
    
    init(host: String, path: String, method: Method, defaultParameters: [String: String]?, parameters: [String: String]?) {
        var allParameters = defaultParameters ?? [:]
        allParameters.merge(parameters ?? [:]) { (_, new) in new }
        
        self.url = "\(host)/\(path)".inject(parameters: allParameters)
        self.method = method
    }
}

extension Request: Equatable {
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.url == rhs.url && lhs.method == rhs.method
    }
}
