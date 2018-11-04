//
//  DownloadRequestBuilding.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownloadRequestBuilding: ApiApplicationRequestBuilding {
    //! So all RequestBuilding protocols will define these two methods.
    // Preferably this would be generic with an ApiCall associated type in RequestBuilding
    // But this will give RequestBuilding a Self requestrment
    // And currently RequestBuilding is used throughout DownKit
    //
    // typealias ApiCall = DownloadApplicationCall

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
