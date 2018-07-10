//
//  ApiApplicationRequestBuilding.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public protocol ApiApplicationRequestBuilding: RequestBuilding {
    var host: String { get }

    func path(for apiCall: ApiApplicationCall) -> String?
    func parameters(for apiCall: ApiApplicationCall) -> [String: String]?
    func authenticationMethod(for apiCall: ApiApplicationCall) -> AuthenticationMethod
    
    func make(for apiCall: ApiApplicationCall) throws -> Request
}

extension ApiApplicationRequestBuilding {
    func parameters(for apiCall: ApiApplicationCall) -> [String: String]? {
        return nil
    }

    func authenticationMethod(for apiCall: ApiApplicationCall) -> AuthenticationMethod {
        return .none
    }
    
    func make(for apiCall: ApiApplicationCall) throws -> Request {
        guard let path = path(for: apiCall) else {
            throw RequestBuildingError.notSupportedError("\(apiCall) call not supported by \(host)")
        }

        return Request(host: host,
                       path: path,
                       method: .get,
                       defaultParameters: nil,
                       parameters: parameters(for: apiCall))
    }
}
