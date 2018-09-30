//
//  ApiApplicationRequestBuilding.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public protocol ApiApplicationRequestBuilding: RequestBuilding {
    func specification(for apiCall: ApiApplicationCall, credentials: UsernamePassword?) -> RequestSpecification?
    func make(for apiCall: ApiApplicationCall, credentials: UsernamePassword?) throws -> Request
}

extension ApiApplicationRequestBuilding {
    func make(for apiCall: ApiApplicationCall, credentials: UsernamePassword? = nil) throws -> Request {
        guard let spec = specification(for: apiCall, credentials: credentials) else {
            throw RequestBuildingError.notSupportedError("\(apiCall) call not supported by \(application.name)")
        }

        return make(from: spec)
    }
}
