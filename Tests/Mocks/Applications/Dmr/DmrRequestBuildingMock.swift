//
//  DmrRequestBuildingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DmrRequestBuildingMock: DmrRequestBuilding {
    struct Stubs {
        var make: Request?
        var specification: RequestSpecification?
    }

    struct Captures {
        var make: Make?
        var specification: Specification?

        struct Make {
            var call: DmrApplicationCall
        }

        struct Specification {
            var call: DmrApplicationCall
        }
    }

    var stubs = Stubs()
    var captures = Captures()

    // DmrRequestBuilding

    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }

    func make(for apiCall: DmrApplicationCall) throws -> Request {
        captures.make = Captures.Make(call: apiCall)

        return stubs.make!
    }

    func specification(for apiCall: DmrApplicationCall) -> RequestSpecification? {
        return stubs.specification
    }
}
