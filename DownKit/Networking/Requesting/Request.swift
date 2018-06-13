//
//  Reqeust.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

struct Request {
    var method: Method
    var url: String
    var parameters: [String: String]?

    enum Method: String {
        case get
        case post
        case put
        case delete
    }
    
    struct Response: DataStoring {
        var statusCode: Int
        var data: Data?
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

private extension String {
    func inject(parameters: [String: Any]) -> String {
        guard let regex = try? NSRegularExpression(pattern: "\\{(\\w{1,})\\}") else {
            return self
        }
        
        var string = self
        let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.count))
        
        matches.reversed().forEach { result in
            let fullRange = Range(result.range, in: string)!
            let fullMatch = String(string[fullRange])
            
            let keyRange = Range(result.range(at: 1), in: string)!
            let key = String(string[keyRange])
            
            if let value = parameters[key] {
                string = string.replacingOccurrences(of: fullMatch, with: "\(value)")
            }
            else {
                print("No value passed for '\(key)' parameter")
            }
        }
        
        return string
    }
}
