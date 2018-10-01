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
import SwiftHash

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
                                                               path: "login/?next=%2F",
                                                               method: .post,
                                                               authenticationMethod: .form,
                                                               formAuthenticationData: expectedFormData)
                    }
                }

                context("build api key call") {
                    context("without credentials") {

                        beforeEach {
                            expectedParamters = [
                                "username": "",
                                "password": ""
                            ]
                            result = sut.specification(for: .apiKey, credentials: nil)
                        }

                        it("builds the specification") {
                            expect(result) == RequestSpecification(host: application.host,
                                                                   path: "getkey/?u={username}&p={password}",
                                                                   parameters: expectedParamters)
                        }
                    }

                    context("with credentials") {
                        var credentials: UsernamePassword!

                        beforeEach {
                            credentials = ("username", "password")
                            expectedParamters = [
                                "username": "14c4b06b824ec593239362517f538b29",
                                "password": "5f4dcc3b5aa765d61d8327deb882cf99"
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
}
