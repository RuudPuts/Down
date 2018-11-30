//
//  SickgearRequestBuilderSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 30/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class SickgearRequestBuilderSpec: QuickSpec {
    override func spec() {
        describe("SickgearRequestBuilder") {
            var sut: SickgearRequestBuilder!
            var result: RequestSpecification?

            var application: DvrApplication!

            beforeEach {
                application = DvrApplication(type: .sickgear, host: "host", apiKey: "key")

                sut = SickgearRequestBuilder(application: application)
            }

            afterEach {
                result = nil
                sut = nil
                application = nil
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
                        let expectedFormData = [
                            "username": credentials.username,
                            "password": credentials.password,
                            "_xsrf": "sickgear",
                        ]

                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "login",
                                                               method: .post,
                                                               headers: ["Cookie": "_xsrf=sickgear"],
                                                               authenticationMethod: .form,
                                                               formAuthenticationData: expectedFormData)
                    }
                }

                context("build api key call") {
                    context("without session cookie") {
                        beforeEach {
                            result = sut.specification(for: .apiKey)
                        }

                        it("builds the specification") {
                            expect(result) == RequestSpecification(host: application.host,
                                                                   path: "config/general")
                        }
                    }

                    context("with session cookie") {
                        var cookie: HTTPCookie!
                        var applicationHost: URL!

                        beforeEach {
                            application.host = "sickgear.com"
                            applicationHost = URL.from(host: application.host)

                            cookie = HTTPCookie(url: applicationHost, key: "sickgear-session-291802983", value: "test_value")
                            CookieBag.instance?.setCookies([cookie], for: applicationHost, mainDocumentURL: nil)

                            result = sut.specification(for: .apiKey)
                        }

                        afterEach {
                            cookie = nil
                            applicationHost = nil
                        }

                        xit("builds the specification") {
                            expect(result) == RequestSpecification(host: application.host,
                                                                   path: "config/general",
                                                                   headers: ["Cookie": "sickgear-session-291802983=test_value"])
                        }
                    }
                }
            }
        }
    }
}

private extension HTTPCookie {
    convenience init?(url: URL, key: String, value: String) {
        let properties: [HTTPCookiePropertyKey : Any] = [
            .domain: url.absoluteString,
            .path: "/",
            .name: key,
            .value: value,
            .secure: "FALSE",
            .expires: NSDate(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 365))
        ]

        self.init(properties: properties)
    }
}
