//
//  DownloadRequestBuildingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DownloadRequestBuildingMock: DownloadRequestBuilding {
    struct Stubs {
        var make = Request(url: "", method: .get)
        var specification: RequestSpecification?
    }
    
    struct Captures {
        var make: Make?
        var specification: Specification?

        struct Make {
            var call: DownloadApplicationCall
        }

        struct Specification {
            var call: DownloadApplicationCall
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DownloadRequestBuilding

    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }

    func make(for apiCall: DownloadApplicationCall) throws -> Request {
        captures.make = Captures.Make(call: apiCall)

        return stubs.make
    }
    
    func specification(for apiCall: DownloadApplicationCall) -> RequestSpecification? {
        return stubs.specification
    }
}
