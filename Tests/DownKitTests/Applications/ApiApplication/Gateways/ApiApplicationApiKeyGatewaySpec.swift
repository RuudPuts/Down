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

            var request: Request!
            var application: ApiApplication!
            var requestBuilder: ApiApplicationRequestBuildingMock!
            var responseParser: ApiApplicationResponseParsingMock!
            var requestExecutor: RequestExecutingMock!

            beforeEach {
                request = Request(url: "http://myapi/show", method: .get)
                application = ApiApplicationMock()
                requestBuilder = ApiApplicationRequestBuildingMock(application: application)
                requestBuilder.stubs.make = request
                requestExecutor = RequestExecutingMock()
                responseParser = ApiApplicationResponseParsingMock()
                responseParser.stubs.parseApiKey = "API_KEY"

                sut = ApiApplicationApiKeyGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
            }

            afterEach {
                sut = nil

                responseParser = nil
                requestExecutor = nil
                requestBuilder = nil
                application = nil
                request = nil
            }

            context("fetching api key") {
                var responseData: Data!
                var result: String!

                beforeEach {
                    responseData = "stubbed data".data(using: .utf8)
                    requestExecutor.stubs.execute = Observable<Response>.just(
                        Response(data: responseData, statusCode: 200, headers: [:])
                    )

                    do {
                        result = try sut
                            .execute()
                            .toBlocking()
                            .first() ?? "FAILED"
                    }
                    catch {
                        fail("Failed to execute gateway: \(error.localizedDescription)")
                    }
                }

                afterEach {
                    result = nil
                    responseData = nil
                }

                it("builds the api key request") {
                    expect(requestBuilder.captures.make?.call) == ApiApplicationCall.apiKey
                }

                it("executes the request") {
                    expect(requestExecutor.captures.execute?.request) == request
                }

                it("parses the api key") {
                    expect(responseParser.captures.parseApiKey?.response.data) == responseData
                }

                it("returns the api key") {
                    expect(result).to(equal("API_KEY"))
                }
            }
        }
    }
}
