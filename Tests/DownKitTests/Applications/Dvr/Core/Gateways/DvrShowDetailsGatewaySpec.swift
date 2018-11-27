//
//  DvrShowDetailsGatewaySpec.swift
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
import Result

class DvrShowDetailsGatewaySpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("DvrShowDetailsGateway") {
            var sut: DvrShowDetailsGateway!
            
            var application: DvrApplication!
            var requestBuilder: DvrRequestBuildingMock!
            var responseParser: DvrResponseParsingMock!
            var requestExecutor: RequestExecutingMock!

            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                requestBuilder = DvrRequestBuildingMock(application: application)
                requestExecutor = RequestExecutingMock()
                responseParser = DvrResponseParsingMock()

                sut = DvrShowDetailsGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
                sut.show = DvrShow(identifier: "1", name: "Show")
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
                    request = Request.defaultStub
                    requestBuilder.stubs.make = request
                    result = try? sut.makeRequest()
                }

                afterEach {
                    result = nil
                    request = nil
                }

                it("builds the show details request") {
                    expect(requestBuilder.captures.make?.call) == DvrApplicationCall.showDetails(sut.show)
                }

                it("returns the request") {
                    expect(result) === request
                }
            }

            describe("parsing the response") {
                var response: Response!
                var updatedShow: DvrShow!
                var result: DvrShow!

                beforeEach {
                    response = Response(data: Data(), statusCode: 200, headers: [:])

                    updatedShow = DvrShow(identifier: "1", name: "UpdatedShow")
                    responseParser.stubs.parseShowDetails = updatedShow

                    result = sut.parse(response: response).value
                }

                afterEach {
                    result = nil
                    updatedShow = nil
                    response = nil
                }

                it("parses the show details") {
                    expect(responseParser.captures.parseShowDetails?.response.data) == Data()
                }

                it("returns the show details") {
                    expect(result) === updatedShow
                }
            }
        }
    }
}
