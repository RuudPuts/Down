//
//  DownloadRequestBuilding.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownloadRequestBuilding: ApiApplicationRequestBuilding {
    func specification(for apiCall: DownloadApplicationCall) -> RequestSpecification?
    func make(for apiCall: DownloadApplicationCall) throws -> Request
}

extension DownloadRequestBuilding {
    func make(for apiCall: DownloadApplicationCall) throws -> Request {
        guard let spec = specification(for: apiCall) else {
            throw RequestBuildingError.notSupportedError("\(apiCall) call not supported by \(application.name)")
        }
        
        return make(from: spec)
    }
}
