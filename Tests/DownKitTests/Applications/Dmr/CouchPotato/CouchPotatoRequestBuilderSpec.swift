//
//  CouchPotatoRequestBuilderSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class CouchPotatoRequestBuilderSpec: QuickSpec {
    override func spec() {
        describe("CouchPotatoRequestBuilder") {
            var sut: CouchPotatoRequestBuilder!
            var result: RequestSpecification?

            var application: DmrApplication!
            var expectedParamters: [String: String]!

            beforeEach {
                application = DmrApplication(type: .couchpotato, host: "host", apiKey: "key")
                expectedParamters = ["apikey": application.apiKey]

                sut = CouchPotatoRequestBuilder(application: application)
            }

            afterEach {
                result = nil
                sut = nil
                expectedParamters = nil
                application = nil
            }

            context("dmr request builder") {
                context("build show list call") {
                    beforeEach {
                        result = sut.specification(for: .movieList)
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}/movie.list",
                                                               parameters: expectedParamters)
                    }
                }
            }

            context("api application request builder") {
                context("build login call") {
                    var credentials: UsernamePassword!
                    var expectedFormData: FormAuthenticationData!

                    beforeEach {
                        credentials = ("username", "password")
                        expectedFormData = FormAuthenticationData(fieldName: ("username", "password"),
                                                                  fieldValue: credentials)

                        result = sut.specification(for: .login, credentials: credentials)
                    }

                    afterEach {
                        credentials = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               authenticationMethod: .form,
                                                               formAuthenticationData: expectedFormData)
                    }
                }

                context("build api key call") {
                    var credentials: UsernamePassword!

                    beforeEach {
                        credentials = ("username", "password")
                        expectedParamters = [
                            "username": credentials.username,
                            "password": credentials.password
                        ]
                        result = sut.specification(for: .apiKey, credentials: credentials)
                    }

                    afterEach {
                        credentials = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "getkey/?u={username}&p={password}",
                                                               parameters: expectedParamters)
                    }
                }
            }
        }
    }
}
