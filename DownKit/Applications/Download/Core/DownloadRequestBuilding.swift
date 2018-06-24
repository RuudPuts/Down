//
//  DownloadRequestBuilding.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownloadRequestBuilding: RequestBuilding {
    var application: DownloadApplication { get }
    init(application: DownloadApplication)
    
    var defaultParameters: [String: String]? { get }
    func path(for apiCall: DownloadApplicationCall) -> String?
    func parameters(for apiCall: DownloadApplicationCall) -> [String: String]?
    func method(for apiCall: DownloadApplicationCall) -> Request.Method
    
    func make(for apiCall: DownloadApplicationCall) throws -> Request
}

extension DownloadRequestBuilding {
    var defaultParameters: [String: String]? {
        return ["apikey": application.apiKey]
    }
    
    func path(for apiCall: DownloadApplicationCall) -> String? {
        return nil
    }
    
    func parameters(for apiCall: DownloadApplicationCall) -> [String: String]? {
        return nil
    }    
    
    func make(for apiCall: DownloadApplicationCall) throws -> Request {
        guard let path = path(for: apiCall) else {
            throw RequestBuildingError.notSupportedError("\(apiCall) call not supported by \(application.name)")
        }
        
        return Request(host: application.host, path: path,
                       method: method(for: apiCall),
                       defaultParameters: defaultParameters,
                       parameters: parameters(for: apiCall))
    }
}
