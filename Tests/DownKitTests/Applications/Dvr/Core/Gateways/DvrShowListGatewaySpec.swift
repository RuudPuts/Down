//
//  DvrShowListGatewaySpec.swift
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

class DvrShowListGatewaySpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("DvrShowListGateway") {
            var sut: DvrShowListGateway!
            
            var application: DvrApplication!
            var requestBuilder: DvrRequestBuildingMock!
            var responseParser: DvrResponseParsingMock!
            var requestExecutor: RequestExecutingMock!
            
            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                requestBuilder = DvrRequestBuildingMock(application: application)
                requestExecutor = RequestExecutingMock()
                responseParser = DvrResponseParsingMock()
                
                sut = DvrShowListGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
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

                it("builds the shows request") {
                    expect(requestBuilder.captures.make?.call) == DvrApplicationCall.showList
                }

                it("returns the request") {
                    expect(result) === request
                }
            }

            describe("parsing the response") {
                var response: Response!
                var shows: [DvrShow]!
                var result: [DvrShow]!

                beforeEach {
                    response = Response(data: Data(), statusCode: 200, headers: [:])

                    shows = [DvrShow(identifier: "1", name: "UpdatedShow")]
                    responseParser.stubs.parseShows = shows

                    result = try? sut.parse(response: response)
                }

                afterEach {
                    result = nil
                    shows = nil
                    response = nil
                }

                it("parses the shows") {
                    expect(responseParser.captures.parseShows?.response.data) == Data()
                }

                it("returns the shows") {
                    expect(result) === shows
                }
            }
        }
    }
    // swiftlint:enable function_body_length
}
