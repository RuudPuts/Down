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
            
            var request: Request!
            var application: DvrApplication!
            var requestBuilder: DvrRequestBuildingMock!
            var responseParser: DvrResponseParsingMock!
            var requestExecutor: RequestExecutingMock!
            
            beforeEach {
                request = Request(url: "http://myapi/show",
                                  method: .get)
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                requestBuilder = DvrRequestBuildingMock(application: application)
                requestBuilder.stubs.make = request
                requestExecutor = RequestExecutingMock()
                responseParser = DvrResponseParsingMock()
                responseParser.stubs.parseShows = [DvrShow(identifier: "1", name: "UpdatedShow", quality: "TestQuality")]
                
                sut = DvrShowListGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
            }
            
            afterEach {
                sut = nil
                
                responseParser = nil
                requestExecutor = nil
                requestBuilder = nil
                application = nil
                request = nil
            }
            
            context("fetching shows") {
                var responseData: Data!
                var result: [DvrShow]!
                
                beforeEach {
                    responseData = "stubbed data".data(using: .utf8)
                    requestExecutor.stubs.execute = Observable<Response>.just(
                        Response(data: responseData, statusCode: 200, headers: [:])
                    )
                    
                    do {
                        result = try sut
                            .observe()
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
                
                it("builds the show list request") {
                    expect(requestBuilder.captures.make?.call) == DvrApplicationCall.showList
                }
                
                it("executes the request") {
                    expect(requestExecutor.captures.execute?.request) == request
                }
                
                it("parses the shows") {
                    expect(responseParser.captures.parseShows?.response.data) == responseData
                }
                
                it("returns the shows") {
                    expect(result).toNot(beNil())
                }
            }
        }
    }
}
