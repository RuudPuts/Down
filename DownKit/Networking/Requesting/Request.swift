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
    var url: URL
    var authenticationMethod: AuthenticationMethod
    var basicAuthenticationData: BasicAuthenticationData?
    var formAuthenticationData: FormAuthenticationData?

    public enum Method: String {
        case get
        case post
        case put
        case delete
    }
    
    init(url: URL,
         method: Method,
         authenticationMethod: AuthenticationMethod = .none,
         basicAuthenticationData: BasicAuthenticationData? = nil,
         formAuthenticationData: FormAuthenticationData? = nil) {

        self.url = url
        self.method = method
        self.authenticationMethod = authenticationMethod
        self.basicAuthenticationData = basicAuthenticationData
        self.formAuthenticationData = formAuthenticationData
    }

    convenience init(host: String,
                     path: String,
                     method: Method,
                     parameters: [String: String]?,
                     authenticationMethod: AuthenticationMethod = .none,
                     basicAuthenticationData: BasicAuthenticationData? = nil,
                     formAuthenticationData: FormAuthenticationData? = nil) {

        let url = "\(host)/\(path)".inject(parameters: parameters ?? [:])

        self.init(url: URL.from(host: url)!,
                  method: method,
                  authenticationMethod: authenticationMethod,
                  basicAuthenticationData: basicAuthenticationData,
                  formAuthenticationData: formAuthenticationData)
    }
}

extension Request: Equatable {
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.url == rhs.url && lhs.method == rhs.method
    }
}
