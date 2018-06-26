//
//  DvrRequestBuilding.swift
//  DownKit
//
//  Created by Ruud Puts on 13/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrRequestBuilding: RequestBuilding {
    var application: DvrApplication { get }
    init(application: DvrApplication)
    
    var defaultParameters: [String: String] { get }
    func path(for apiCall: DvrApplicationCall) -> String?
    func parameters(for apiCall: DvrApplicationCall) -> [String: String]?
    func method(for apiCall: DvrApplicationCall) -> Request.Method
    
    func make(for apiCall: DvrApplicationCall) throws -> Request
}

extension DvrRequestBuilding {
    var defaultParameters: [String: String] {
        return ["apikey": application.apiKey]
    }
    
    func path(for apiCall: DownloadApplicationCall) -> String? {
        return nil
    }
    
    func parameters(for apiCall: DownloadApplicationCall) -> [String: String]? {
        return nil
    }
    
    func make(for apiCall: DvrApplicationCall) throws -> Request {
        guard let path = path(for: apiCall) else {
            throw RequestBuildingError.notSupportedError("\(apiCall) call not supported by \(application.name)")
        }
        
        return Request(host: application.host, path: path,
                       method: method(for: apiCall),
                       defaultParameters: defaultParameters,
                       parameters: parameters(for: apiCall))
    }
}
