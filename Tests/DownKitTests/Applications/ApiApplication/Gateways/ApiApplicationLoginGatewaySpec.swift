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
                responseParser.stubs.parseLogin = .success

                sut = ApiApplicationLoginGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
            }

            afterEach {
                sut = nil

                responseParser = nil
                requestExecutor = nil
                requestBuilder = nil
                application = nil
                request = nil
            }

            context("fetching Login") {
                var responseData: Data!
                var result: LoginResult!

                beforeEach {
                    responseData = "stubbed data".data(using: .utf8)
                    requestExecutor.stubs.execute = Observable<Response>.just(
                        Response(data: responseData, statusCode: 200, headers: [:])
                    )

                    do {
                        result = try sut
                            .execute()
                            .toBlocking()
                            .first()
                    }
                    catch {
                        fail("Failed to execute gateway: \(error.localizedDescription)")
                    }
                }

                afterEach {
                    result = nil
                    responseData = nil
                }

                it("builds the login request") {
                    expect(requestBuilder.captures.make?.call) == ApiApplicationCall.login
                }

                it("executes the request") {
                    expect(requestExecutor.captures.execute?.request) == request
                }

                it("parses the login response") {
                    expect(responseParser.captures.parseLogin?.response.data) == responseData
                }

                it("returns success result") {
                    expect(result).to(equal(.success))
                }
            }
        }
    }
}
