//
//  DvrRequestBuildingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DvrRequestBuildingMock: DvrRequestBuilding {
    struct Stubs {
        var make: Request?
        var defaultParameters: [String: String] = [:]
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
    
    var application: ApiApplication
    
    required init(application: ApiApplication) {
        self.application = application
    }
    
    func specification(for apiCall: DvrApplicationCall) -> RequestSpecification? {
        return nil
    }
}
