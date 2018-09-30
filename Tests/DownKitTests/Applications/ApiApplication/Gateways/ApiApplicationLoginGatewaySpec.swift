//
//  ApiApplicationLoginGatewaySpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxBlocking
import RxSwift
import Quick
import Nimble

class ApiApplicationLoginGatewaySpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("ApiApplicationLoginGateway") {
            var sut: ApiApplicationLoginGateway!

            var application: ApiApplication!
            var requestBuilder: ApiApplicationRequestBuildingMock!
            var responseParser: ApiApplicationResponseParsingMock!
            var requestExecutor: RequestExecutingMock!

            beforeEach {
                application = ApiApplicationMock()
                requestBuilder = ApiApplicationRequestBuildingMock(application: application)
                requestExecutor = RequestExecutingMock()
                responseParser = ApiApplicationResponseParsingMock()
                responseParser.stubs.parseLogin = .success

                sut = ApiApplicationLoginGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
            }

            afterEach {
                sut = nil

                responseParser = nil
                requestExecutor = nil
                requestBuilder = nil
                application = nil
            }

            describe("making the request") {
                var request: Request!
                var result: Request!

                beforeEach {
                    request = Request(url: "http://myapi/login", method: .get)
                    requestBuilder.stubs.make = request
                    result = try? sut.makeRequest()
                }

                afterEach {
                    result = nil
                    request = nil
                }

                it("builds the login request") {
                    expect(requestBuilder.captures.make?.call) == ApiApplicationCall.login
                }

                it("returns the request") {
                    expect(result) === request
                }
            }

            describe("parsing the response") {
                var response: Response!

                var result: LoginResult!

                beforeEach {
                    response = Response(data: Data(), statusCode: 200, headers: [:])

                    responseParser.stubs.parseLogin = .success

                    result = try! sut.parse(response: response)
                }

                afterEach {
                    result = nil
                    response = nil
                }

                it("parses the login result") {
                    expect(responseParser.captures.parseLogin?.response.data) == Data()
                }

                it("returns the login result") {
                    expect(result) == .success
                }
            }
        }
    }
}
