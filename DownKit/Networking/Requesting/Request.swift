//
//  Reqeust.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public struct Request {
    var method: Method
    var url: String
    var parameters: [String: String]?

    public enum Method: String {
        case get
        case post
        case put
        case delete
    }
    
    public struct Response: DataStoring {
        public var data: Data?
        var statusCode: Int
        var headers: [AnyHashable: Any]
    }
    
    init(url: String, method: Method, parameters: [String: String]?) {
        self.url = url
        self.method = method
        self.parameters = parameters
    }
    
    init(host: String, path: String, method: Method, defaultParameters: [String: String]?, parameters: [String: String]?) {
        var allParameters = defaultParameters ?? [:]
        allParameters.merge(parameters ?? [:]) { (_, new) in new }
        
        self.url = "\(host)/\(path)".inject(parameters: allParameters)
        self.method = method
        self.parameters = allParameters.count > 0 ? allParameters : nil
    }
}

extension Request {
    func asUrlRequest() -> URLRequest? {
        guard let url = URL(string: self.url) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        return request
    }
}
