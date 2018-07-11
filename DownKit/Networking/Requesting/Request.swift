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
    var authenticationMethod: AuthenticationMethod
    var basicAuthenticationData: BasicAuthenticationData?
    var formAuthenticationData: FormAuthenticationData?

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
    
    init(url: String,
         parameters: [String: String]?,
         method: Method,
         authenticationMethod: AuthenticationMethod = .none,
         basicAuthenticationData: BasicAuthenticationData? = nil,
         formAuthenticationData: FormAuthenticationData? = nil) {
        self.url = url.inject(parameters: parameters)
        self.method = method
        self.authenticationMethod = authenticationMethod
    }

    //! Remove after request specification refactor
    init(host: String, path: String,
         method: Method,
         defaultParameters: [String: String]?,
         parameters: [String: String]?,
         authenticationMethod: AuthenticationMethod = .none,
         basicAuthenticationData: BasicAuthenticationData? = nil,
         formAuthenticationData: FormAuthenticationData? = nil) {
        var allParameters = defaultParameters ?? [:]
        allParameters.merge(parameters ?? [:]) { (_, new) in new }
        
        self.url = "\(host)/\(path)".inject(parameters: allParameters)
        self.method = method
        self.authenticationMethod = authenticationMethod
    }
}

extension Request: Equatable {
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.url == rhs.url && lhs.method == rhs.method
    }
}
