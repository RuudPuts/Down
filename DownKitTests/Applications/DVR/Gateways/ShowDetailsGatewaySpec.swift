//
//  ShowDetailsGatewaySpec.swift
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

class ShowDetailsGatewaySpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("ShowDetailsGateway") {
            var sut: ShowDetailsGateway!
            var config: ShowDetailsGateway.Config!
            var show: DvrShow!
            
            var request: Request!
            var requestBuilder: DvrRequestBuildingMock!
            var application: DvrApplicationMock!
            var responseParser: DvrResponseParserMock!
            var responseMapper: DvrShowDetailsResponseMapper!
            var requestExecutorFactory: RequestExecutorProducingMock!
            
            beforeEach {
                request = Request(url: "http://myapi/show/identifier",
                                  method: .get, parameters: nil)
                application = DvrApplicationMock()
                requestBuilder = DvrRequestBuildingMock(application: application)
                requestBuilder.stubs.make = request
                application.stubs.requestBuilder = requestBuilder
                requestExecutorFactory = RequestExecutorProducingMock()
                
                responseParser = DvrResponseParserMock()
                responseParser.stubs.parseShowDetails = DvrShow(identifier: "1", name: "UpdatedShow", quality: "TestQuality")
                responseMapper = DvrShowDetailsResponseMapper(parser: responseParser)
                
                config = ShowDetailsGateway.Config(application: application,
                                                   responseMapper: responseMapper,
                                                   requestExecutorFactory: requestExecutorFactory)
                show = DvrShow(identifier: "1", name: "TestShow", quality: "TestQuality")
                sut = ShowDetailsGateway(config: config, show: show)
            }
            
            afterEach {
                sut = nil
                config = nil
                show = nil
                
                responseMapper = nil
                responseParser = nil
                
                requestExecutorFactory = nil
                requestBuilder = nil
                application = nil
                request = nil
            }
            
            context("getting show details") {
                var requestExecutor: RequestExecutingMock!
                var responseData: Data!
                var result: DvrShow!
                
                beforeEach {
                    responseData = "stubbed data".data(using: .utf8)
                    
                    requestExecutor = RequestExecutingMock()
                    requestExecutor.stubs.execute = Observable<Request.Response>.just(
                        Request.Response(data: responseData, statusCode: 200, headers: [:])
                    )
                    requestExecutorFactory.stubs.make = requestExecutor
                    
                    // swiftlint:disable force_try
                    result = try! sut
                        .get()
                        .toBlocking()
                        .first()
                }
                
                afterEach {
                    result = nil
                    requestExecutor = nil
                    responseData = nil
                }
                
                it("builds the show details request for show") {
                    expect(requestBuilder.captures.make?.call) == DvrApplicationCall.showDetails(show)
                }
                
                it("makes the request executor") {
                    expect(requestExecutorFactory.captures.make?.request) == requestBuilder.stubs.make
                }
                
                it("parses the result") {
                    //! The code actually calls the mapper, but currently it can't be mocked
                    //! As gateway defines a spefic implementation of DvrResponseMapper
                    expect(responseParser.captures.parseShowDetails?.storage.data) == responseData
                }
                
                it("returns updated show") {
                    expect(result.name) == "UpdatedShow"
                }
            }
        }
    }
}
