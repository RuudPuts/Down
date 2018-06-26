//
//  ApiApplicationRequestBuliding.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public protocol ApiApplicationRequestBuliding: RequestBuilding {
    var application: DvrApplication { get }
    init(application: DvrApplication)
    
    var defaultParameters: [String: String] { get }
    func path(for apiCall: ApiApplicationCall) -> String?
    func parameters(for apiCall: ApiApplicationCall) -> [String: String]?
    func method(for apiCall: ApiApplicationCall) -> Request.Method
    
    func make(for apiCall: ApiApplicationCall) throws -> Request
}

extension ApiApplicationRequestBuliding {
    var defaultParameters: [String: String] {
        return [:]
    }
    
    func path(for apiCall: DownloadApplicationCall) -> String? {
        return nil
    }
    
    func parameters(for apiCall: DownloadApplicationCall) -> [String: String]? {
        return nil
    }
    
    func make(for apiCall: ApiApplicationCall) throws -> Request {
        guard let path = path(for: apiCall) else {
            throw RequestBuildingError.notSupportedError("\(apiCall) call not supported by \(application.name)")
        }
        
        return Request(host: application.host, path: path,
                       method: method(for: apiCall),
                       defaultParameters: defaultParameters,
                       parameters: parameters(for: apiCall))
    }
}
