//
//  ShowListGatewaySpec.swift
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

class ShowListGatewaySpec: QuickSpec {
    override func spec() {
        describe("ShowListGateway") {
            var sut: ShowListGateway!
            var config: ShowListGateway.Config!
            
            var request: Request!
            var requestBuilder: DvrRequestBuildingMock!
            var application: DvrApplicationMock!
            var responseParser: DvrResponseParserMock!
            var responseMapper: DvrShowsResponseMapper!
            var requestExecutorFactory: RequestExecutorProducingMock!
            
            beforeEach {
                request = Request(url: "http://myapi/shows",
                                  method: .get, parameters: nil)
                application = DvrApplicationMock()
                requestBuilder = DvrRequestBuildingMock(application: application)
                requestBuilder.stubs.make = request
                application.stubs.requestBuilder = requestBuilder
                requestExecutorFactory = RequestExecutorProducingMock()
                
                responseParser = DvrResponseParserMock()
                responseParser.stubs.parseShows = [DvrShow(identifier: "1", name: "TestShow", quality: "TestQuality")]
                responseMapper = DvrShowsResponseMapper(parser: responseParser)
                
                config = ShowListGateway.Config(application: application,
                                                responseMapper: responseMapper,
                                                requestExecutorFactory: requestExecutorFactory)
                sut = ShowListGateway(config: config)
            }
            
            afterEach {
                sut = nil
                config = nil
                
                responseMapper = nil
                responseParser = nil
                
                requestExecutorFactory = nil
                requestBuilder = nil
                application = nil
                request = nil
            }
            
            context("getting shows") {
                var requestExecutor: RequestExecutingMock!
                var responseData: Data!
                var result: [DvrShow]!
                
                beforeEach {
                    responseData = "stubbed data".data(using: .utf8)
                    
                    requestExecutor = RequestExecutingMock()
                    requestExecutor.stubs.execute = Observable<Request.Response>.just(
                        Request.Response(data: responseData, statusCode: 200, headers: [:])
                    )
                    requestExecutorFactory.stubs.make = requestExecutor
                    
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
                
                it("builds the show list request") {
                    expect(requestBuilder.captures.make?.call) == DvrApplicationCall.showList
                }
                
                it("makes the request executor") {
                    expect(requestExecutorFactory.captures.make?.request) == requestBuilder.stubs.make
                }
                
                it("parses the result") {
                    //! The code actually calls the mapper, but currently it can't be mocked
                    //! As gateway defines a spefic implementation of DvrResponseMapper
                    expect(responseParser.captures.parseShows?.storage.data) == responseData
                }
                
                it("returns 1 show") {
                    expect(result.count) == 1
                }
            }
        }
    }
}
