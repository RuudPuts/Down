//
//  DvrRequestBuildingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DvrRequestBuildingMock : DvrRequestBuilding {
    struct Stubs {
        var make: Request?
        var defaultParameters: [String: String]?
        var path: String?
        var parameters: [String: String]?
        var method: Request.Method = .get
    }
    
    struct Captures {
        var make: Make?
        var path: CallCapture?
        var parameters: CallCapture?
        var method: CallCapture?
        
        struct Make {
            var call: DvrApplicationCall
        }
        
        struct CallCapture {
            let apiCall: DvrApplicationCall
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DvrRequestBuilding
    
    var application: DvrApplication
    
    required init(application: DvrApplication) {
        self.application = application
    }
    
    func make(for apiCall: DvrApplicationCall) throws -> Request {
        captures.make = Captures.Make(call: apiCall)
        
        guard let stubbed = stubs.make else {
            throw RequestBuildingError.notSupportedError("Stubs.make expected to be set")
        }
        
        return stubbed
    }
    
    var defaultParameters: [String : String]? { return stubs.defaultParameters }
    
    func path(for apiCall: DvrApplicationCall) -> String? {
        captures.path = Captures.CallCapture(apiCall: apiCall)
        return stubs.path
    }
    
    func parameters(for apiCall: DvrApplicationCall) -> [String : String]? {
        captures.parameters = Captures.CallCapture(apiCall: apiCall)
        return stubs.parameters
    }
    
    func method(for apiCall: DvrApplicationCall) -> Request.Method {
        captures.method = Captures.CallCapture(apiCall: apiCall)
        return stubs.method
    }
}
