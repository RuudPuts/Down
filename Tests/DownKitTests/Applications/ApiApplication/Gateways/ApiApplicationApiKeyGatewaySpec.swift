//
//  ApiApplicationApiKeyGatewaySpec.swift
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

class ApiApplicationApiKeyGatewaySpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("ApiApplicationApiKeyGateway") {
            var sut: ApiApplicationApiKeyGateway!

            var application: ApiApplication!
            var requestBuilder: ApiApplicationRequestBuildingMock!
            var responseParser: ApiApplicationResponseParsingMock!
            var requestExecutor: RequestExecutingMock!

            beforeEach {
                application = ApiApplicationMock()
                requestBuilder = ApiApplicationRequestBuildingMock(application: application)
                requestExecutor = RequestExecutingMock()
                responseParser = ApiApplicationResponseParsingMock()

                sut = ApiApplicationApiKeyGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
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
                    request = Request(url: "http://myapi/apikey", method: .get)
                    requestBuilder.stubs.make = request
                    result = try? sut.makeRequest()
                }

                afterEach {
                    result = nil
                }

                it("builds the api key request") {
                    expect(requestBuilder.captures.make?.call) == ApiApplicationCall.apiKey
                }

                it("returns the request") {
                    expect(result) === request
                }
            }

            describe("parsing the response") {
                var response: Response!
                var result: String!

                beforeEach {
                    response = Response(data: Data(), statusCode: 200, headers: [:])

                    responseParser.stubs.parseApiKey = "API_KEY"

                    result = try! sut.parse(response: response)
                }

                afterEach {
                    result = nil
                    response = nil
                }

                it("parses the api key") {
                    expect(responseParser.captures.parseApiKey?.response.data) == Data()
                }

                it("returns the apikey") {
                    expect(result) == "API_KEY"
                }
            }
        }
    }
}
