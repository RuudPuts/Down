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

extension RequestSpecification: Equatable {
    public static func == (lhs: RequestSpecification, rhs: RequestSpecification) -> Bool {
        let defaultUsernamePassword = ("","")
        let defaultFormData = FormAuthenticationData(fieldName: defaultUsernamePassword, fieldValue: defaultUsernamePassword)

        return lhs.host == rhs.host
            && lhs.path == rhs.path
            && lhs.method == rhs.method
            && lhs.parameters == rhs.parameters
            && lhs.authenticationMethod == rhs.authenticationMethod
            && lhs.basicAuthenticationData ?? defaultUsernamePassword == rhs.basicAuthenticationData ?? defaultUsernamePassword
            && lhs.formAuthenticationData ?? defaultFormData == rhs.formAuthenticationData ?? defaultFormData
    }
}
