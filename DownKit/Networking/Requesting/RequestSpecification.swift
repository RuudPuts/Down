//
//  RequestSpecification.swift
//  DownKit
//
//  Created by Ruud Puts on 11/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public struct RequestSpecification {
    let host: String
    let path: String

    let method: Request.Method
    let parameters: [String: String]?

    let authenticationMethod: AuthenticationMethod
    let basicAuthenticationData: BasicAuthenticationData?
    let formAuthenticationData: FormAuthenticationData?

    init(host: String = "", path: String = "", method: Request.Method = .get, parameters: [String: String] = [:], authenticationMethod: AuthenticationMethod = .none, basicAuthenticationData: BasicAuthenticationData? = nil, formAuthenticationData: FormAuthenticationData? = nil) {
        self.host = host
        self.path = path
        self.method = method
        self.parameters = parameters
        self.authenticationMethod = authenticationMethod
        self.basicAuthenticationData = basicAuthenticationData
        self.formAuthenticationData = formAuthenticationData
    }
}
