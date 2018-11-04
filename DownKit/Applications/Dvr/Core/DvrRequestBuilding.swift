//
//  DvrRequestBuilding.swift
//  DownKit
//
//  Created by Ruud Puts on 13/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrRequestBuilding: ApiApplicationRequestBuilding {
    func specification(for apiCall: DvrApplicationCall) -> RequestSpecification?
    func make(for apiCall: DvrApplicationCall) throws -> Request
}

extension DvrRequestBuilding {
    func make(for apiCall: DvrApplicationCall) throws -> Request {
        guard let spec = specification(for: apiCall) else {
            throw RequestBuildingError.notSupportedError("\(apiCall) call not supported by \(application.name)")
        }

        return make(from: spec)
    }
}
