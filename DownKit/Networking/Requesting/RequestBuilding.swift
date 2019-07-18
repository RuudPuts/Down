//
//  RequestBuilding.swift
//  Down
//
//  Created by Ruud Puts on 08/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol RequestBuilding {
    var application: ApiApplication { get }
    init(application: ApiApplication)

    func make(from spec: RequestSpecification) -> Request
}

extension RequestBuilding {
    func make(from spec: RequestSpecification) -> Request {
        return Request(
            host: spec.host,
            path: spec.path,
            parameters: spec.parameters,
            method: spec.method,
            headers: spec.headers,
            authenticationMethod: spec.authenticationMethod,
            basicAuthenticationData: spec.basicAuthenticationData,
            formAuthenticationData: spec.formAuthenticationData
        )
    }

    func makeDefaultFormAuthenticationData(with credentials: UsernamePassword?) -> FormAuthenticationData? {
        guard let credentials = credentials else {
            return nil
        }

        return [
            "username": credentials.username,
            "password": credentials.password
        ]
    }
}

enum RequestBuildingError: Error {
    case notSupportedError(String)
}

extension RequestBuildingError: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .notSupportedError(let message):
            hasher.combine("1\(message.hashValue)")
        }
    }
    
    public static func == (lhs: RequestBuildingError, rhs: RequestBuildingError) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
