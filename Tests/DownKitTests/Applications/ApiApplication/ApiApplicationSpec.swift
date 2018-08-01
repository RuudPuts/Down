//
//  ApiApplicationSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 01/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class ApiApplicationSpec: QuickSpec {
    override func spec() {
        describe("ApplicationAdditionsFactory") {
            var sut: ApiApplication!

            beforeEach {
                sut = ApiApplicationImpl(host: "http://192.168.1.1", apiKey: "kd9q0d89aij209d8aj")
            }

            afterEach {
                sut = nil
            }

            context("is configured") {
                var configured: Bool!

                afterEach {
                    configured = nil
                }

                context("valid host and apikey") {
                    beforeEach {
                        configured = sut.isConfigured
                    }

                    it("is configured") {
                        expect(configured) == true
                    }
                }

                context("no host") {
                    beforeEach {
                        sut.host = ""
                        configured = sut.isConfigured
                    }

                    it("is not configured") {
                        expect(configured) == false
                    }
                }

                context("no apikey") {
                    beforeEach {
                        sut.apiKey = ""
                        configured = sut.isConfigured
                    }

                    it("is not configured") {
                        expect(configured) == false
                    }
                }
            }
        }
    }
}

private class ApiApplicationImpl: ApiApplication {
    var name: String = "ApiApplicationImpl"
    var host: String
    var apiKey: String
    var type: ApiApplicationType = .download

    init(host: String, apiKey: String) {
        self.host = host
        self.apiKey = apiKey
    }

    func copy() -> Any {
        return self
    }
}
