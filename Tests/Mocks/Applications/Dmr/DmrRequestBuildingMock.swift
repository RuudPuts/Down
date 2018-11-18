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
        var application: ApiApplication!

        var make: Request?
        var specification: RequestSpecification?
    }

    struct Captures {
        var make: Make?
        var makeCredentials: MakeCredentials?
        var specification: Specification?
        var specificationCredentials: SpecificationCredentials?

        struct Make {
            var call: DmrApplicationCall
        }

        struct MakeCredentials {
            var call: ApiApplicationCall
            var credentials: UsernamePassword?
        }

        struct Specification {
            var call: DmrApplicationCall
        }

        struct SpecificationCredentials {
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

    // DmrRequestBuilding

    func make(for apiCall: DmrApplicationCall) throws -> Request {
        captures.make = Captures.Make(call: apiCall)

        return stubs.make!
    }

    func specification(for apiCall: DmrApplicationCall) -> RequestSpecification? {
        return stubs.specification
    }

    // ApiApplicationRequestBuilding

    func make(for apiCall: ApiApplicationCall, credentials: UsernamePassword?) throws -> Request {
        captures.makeCredentials = Captures.MakeCredentials(call: apiCall, credentials: credentials)

        return stubs.make!
    }

    func specification(for apiCall: ApiApplicationCall, credentials: UsernamePassword?) -> RequestSpecification? {
        captures.specificationCredentials = Captures.SpecificationCredentials(call: apiCall, credentials: credentials)

        return stubs.specification
    }
}
