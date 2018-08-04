//
//  SickbeardRequestBuilderSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class SickbeardRequestBuilderSpec: QuickSpec {
    override func spec() {
        describe("SickbeardRequestBuilder") {
            var sut: SickbeardRequestBuilder!
            var result: RequestSpecification?

            var application: DvrApplication!
            var expectedParamters: [String: String]!

            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                expectedParamters = ["apikey": application.apiKey]

                sut = SickbeardRequestBuilder(application: application)
            }

            afterEach {
                result = nil
                sut = nil
                expectedParamters = nil
                application = nil
            }

            context("dvr request builder") {
                context("build show list call") {
                    beforeEach {
                        result = sut.specification(for: .showList)
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=shows",
                                                               parameters: expectedParamters)
                    }
                }

                context("build show details call") {
                    var show: DvrShow!

                    beforeEach {
                        show = DvrShow(identifier: "0", name: "TestShow")
                        expectedParamters.merge(["id": show.identifier], uniquingKeysWith: { $1 })

                        result = sut.specification(for: .showDetails(show))
                    }

                    afterEach {
                        show = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=show.seasons%7Cshow&tvdbid={id}",
                                                               parameters: expectedParamters)
                    }
                }

                context("build add show call") {
                    var show: DvrShow!
                    var status: DvrEpisode.Status!

                    beforeEach {
                        show = DvrShow(identifier: "128", name: "TestShow")
                        status = .wanted

                        expectedParamters.merge([
                                "id": show.identifier,
                                "status": status.rawValue
                            ], uniquingKeysWith: { $1 })

                        result = sut.specification(for: .addShow(show, status))
                    }

                    afterEach {
                        status = nil
                        show = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=show.addnew&tvdbid={id}&status={status}",
                                                               parameters: expectedParamters)
                    }
                }
            }

            context("api application request builder") {
                context("build login call") {
                    var credentials: UsernamePassword!

                    beforeEach {
                        credentials = ("username", "password")
                        result = sut.specification(for: .login, credentials: credentials)
                    }

                    afterEach {
                        credentials = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               authenticationMethod: .basic,
                                                               basicAuthenticationData: credentials)
                    }
                }

                context("build api key call") {
                    beforeEach {
                        result = sut.specification(for: .apiKey)
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "config/general")
                    }
                }
            }
        }
    }
}
