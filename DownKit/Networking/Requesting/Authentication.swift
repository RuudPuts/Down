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

public typealias UsernamePassword = (username: String, password: String)
public typealias BasicAuthenticationData = UsernamePassword

public struct FormAuthenticationData {
    let fieldName: UsernamePassword
    let fieldValue: UsernamePassword
}
