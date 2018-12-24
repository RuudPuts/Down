//
//  Reqeust.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public class Request {
    typealias Headers = [String: String]

    var method: Method
    var url: URL
    var headers: Headers?
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
         headers: Headers? = nil,
         authenticationMethod: AuthenticationMethod = .none,
         basicAuthenticationData: BasicAuthenticationData? = nil,
         formAuthenticationData: FormAuthenticationData? = nil) {

        self.url = url
        self.method = method
        self.headers = headers
        self.authenticationMethod = authenticationMethod
        self.basicAuthenticationData = basicAuthenticationData
        self.formAuthenticationData = formAuthenticationData
    }

    convenience init(host: String,
                     path: String,
                     parameters: [String: String]?,
                     method: Method,
                     headers: Headers? = nil,
                     authenticationMethod: AuthenticationMethod = .none,
                     basicAuthenticationData: BasicAuthenticationData? = nil,
                     formAuthenticationData: FormAuthenticationData? = nil) {

        let encodedParameters = (parameters ?? [:]).mapValues {
            $0.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        }
        let injectedPath = path.inject(parameters: encodedParameters)

        self.init(url: URL.from(host: "\(host)/\(injectedPath)")!,
                  method: method,
                  headers: headers,
                  authenticationMethod: authenticationMethod,
                  basicAuthenticationData: basicAuthenticationData,
                  formAuthenticationData: formAuthenticationData)
    }
}

extension Request: Equatable {
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.url == rhs.url
            && lhs.method == rhs.method
            && lhs.headers == rhs.headers
    }
}
