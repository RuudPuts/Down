//
//  SickgearResponseParserSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 30/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble
import RealmSwift
import SwiftyJSON

class SickgearResponseParserSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("SickgearResponseParser") {
            var sut: SickgearResponseParser!
            var response: Response!

            beforeEach {
                sut = SickgearResponseParser(application: ApiApplicationMock())
                response = Response.defaultStub
            }

            afterEach {
                response = nil
                sut = nil
            }

            context("parse login response") {
                var result: LoginResult!

                afterEach {
                    result = nil
                }

                context("without valid server header") {
                    context("succesful login") {
                        beforeEach {
                            response = Response(data: nil, statusCode: 200, headers: nil)
                            result = sut.parseLoggedIn(from: response).value
                        }

                        it("returns failed") {
                            expect(result) == .failed
                        }
                    }
                }

                context("with valid server header") {
                    var headers: [String: String]?

                    beforeEach {
                        headers = ["Server": "TornadoServer/Test"]
                    }

                    afterEach {
                        headers = nil
                    }

                    context("succesful login") {
                        beforeEach {
                            response = Response(data: nil, statusCode: 200, headers: headers)
                            result = sut.parseLoggedIn(from: response).value
                        }

                        it("returns success") {
                            expect(result) == .success
                        }
                    }

                    context("failed login") {
                        beforeEach {
                            response = Response(data: nil, statusCode: 400, headers: headers)
                            result = sut.parseLoggedIn(from: response).value
                        }

                        it("returns authentication required") {
                            expect(result) == .authenticationRequired
                        }
                    }
                }
            }
        }
    }
}
