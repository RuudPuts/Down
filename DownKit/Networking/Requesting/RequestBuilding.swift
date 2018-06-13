//
//  RequestBuilding.swift
//  Down
//
//  Created by Ruud Puts on 08/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol RequestBuilding { }

protocol DvrRequestBuilding: RequestBuilding {
    var application: DvrApplication { get }
    init(application: DvrApplication)
    
    var defaultParameters: [String: String]? { get }
    func path(for apiCall: DvrApplicationCall) -> String?
    func parameters(for apiCall: DvrApplicationCall) -> [String: String]?
    func method(for apiCall: DvrApplicationCall) -> Request.Method
    
    func make(for apiCall: DvrApplicationCall) -> Request?
}

extension DvrRequestBuilding {
    func make(for apiCall: DvrApplicationCall) -> Request? {
        guard let path = path(for: apiCall) else {
            return nil
        }
        
        return Request(host: application.host, path: path,
                       method: method(for: apiCall),
                       defaultParameters: defaultParameters,
                       parameters: parameters(for: apiCall))
    }
}
