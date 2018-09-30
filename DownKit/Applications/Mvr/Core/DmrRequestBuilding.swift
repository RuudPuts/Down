//
//  DmrRequestBuilding.swift
//  DownKit
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DmrRequestBuilding: RequestBuilding {
    func specification(for apiCall: DmrApplicationCall) -> RequestSpecification?
    func make(for apiCall: DmrApplicationCall) throws -> Request
}

extension DmrRequestBuilding {
    func make(for apiCall: DmrApplicationCall) throws -> Request {
        guard let spec = specification(for: apiCall) else {
            throw RequestBuildingError.notSupportedError("\(apiCall) call not supported by \(application.name)")
        }

        return make(from: spec)
    }
}
