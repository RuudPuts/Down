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
        var specification: RequestSpecification?
    }

    struct Captures {
        var make: Make?
        var makeCredentials: MakeCredentials?
        var specification: Specification?
        var specificationCredentials: SpecificationCredentials?

        struct Make {
            var call: DvrApplicationCall
        }

        struct MakeCredentials {
            var call: ApiApplicationCall
            var credentials: UsernamePassword?
        }

        struct Specification {
            var call: DvrApplicationCall
        }

        struct SpecificationCredentials {
            var call: ApiApplicationCall
            var credentials: UsernamePassword?
        }
    }

    var stubs = Stubs()
    var captures = Captures()

    // DvrRequestBuilding

    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }

    func make(for apiCall: DvrApplicationCall) throws -> Request {
        captures.make = Captures.Make(call: apiCall)

        return stubs.make!
    }

    func specification(for apiCall: DvrApplicationCall) -> RequestSpecification? {
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
