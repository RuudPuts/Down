//
//  Authentication.swift
//  DownKit
//
//  Created by Ruud Puts on 10/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public enum AuthenticationMethod {
    case none
    case basic
    case form
}

public struct BasicAuthenticationData {
    let username: String
    let password: String
}

public struct FormAuthenticationData {
    let fieldName: (username: String, password: String)
    let fieldValue: (username: String, password: String)
}
