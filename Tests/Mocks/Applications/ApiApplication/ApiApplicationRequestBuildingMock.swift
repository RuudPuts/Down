//
//  ApiApplicationRequestBuildingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class ApiApplicationRequestBuildingMock: ApiApplicationRequestBuilding {
    struct Stubs {
        var application: ApiApplication!

        var make: Request?
        var specification: RequestSpecification?
    }
    
    struct Captures {
        var make: Make?
        var specification: Specification?

        struct Make {
            var call: ApiApplicationCall
            var credentials: UsernamePassword?
        }

        struct Specification {
            var call: ApiApplicationCall
            var credentials: UsernamePassword?
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()

    var application: ApiApplication {
        return stubs.application
    }

    required init(application: ApiApplication) {
        stubs.application = application
    }

    convenience init() {
        self.init(application: ApiApplicationMock())
    }
    
    // ApiApplicationRequestBuilding

    func make(for apiCall: ApiApplicationCall, credentials: UsernamePassword?) throws -> Request {
        captures.make = Captures.Make(call: apiCall, credentials: credentials)

        return stubs.make!
    }

    func specification(for apiCall: ApiApplicationCall, credentials: UsernamePassword?) -> RequestSpecification? {
        captures.specification = Captures.Specification(call: apiCall, credentials: credentials)

        return stubs.specification
    }
}
