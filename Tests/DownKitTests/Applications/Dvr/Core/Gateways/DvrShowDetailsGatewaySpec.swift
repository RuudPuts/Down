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

class DvrShowDetailsGatewaySpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("DvrShowDetailsGateway") {
            var sut: DvrShowDetailsGateway!
            
            var request: Request!
            var application: DvrApplication!
            var requestBuilder: DvrRequestBuildingMock!
            var responseParser: DvrResponseParsingMock!
            var requestExecutor: RequestExecutingMock!
            
            beforeEach {
                request = Request(url: "http://myapi/show/identifier",
                                  method: .get)
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                requestBuilder = DvrRequestBuildingMock(application: application)
                requestBuilder.stubs.make = request
                requestExecutor = RequestExecutingMock()
                responseParser = DvrResponseParsingMock()
                responseParser.stubs.parseShowDetails = DvrShow(identifier: "1", name: "UpdatedShow", quality: "TestQuality")
            }
            
            afterEach {
                sut = nil
                
                responseParser = nil
                requestExecutor = nil
                requestBuilder = nil
                application = nil
                request = nil
            }
            
            context("without show") {
                beforeEach {
                    sut = DvrShowDetailsGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
                }
            }
            
            context("with show") {
                var show: DvrShow!
                
                beforeEach {
                    show = DvrShow(identifier: "1", name: "TestShow", quality: "TestQuality")
                    sut = DvrShowDetailsGateway(show: show, builder: requestBuilder, parser: responseParser, executor: requestExecutor)
                }
                
                afterEach {
                    show = nil
                }
                
                context("getting details") {
                    var responseData: Data!
                    var result: DvrShow!
                    
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
                    
                    it("builds the show details request for show") {
                        expect(requestBuilder.captures.make?.call) == DvrApplicationCall.showDetails(show)
                    }
                    
                    it("executes the request") {
                        expect(requestExecutor.captures.execute?.request) == request
                    }
                    
                    it("parses the show details") {
                        expect(responseParser.captures.parseShowDetails?.response.data) == responseData
                    }
                    
//                    it("returns updated show") {
//                        expect(result.name) == "UpdatedShow"
//                    }
                }
            }
        }
    }
}
