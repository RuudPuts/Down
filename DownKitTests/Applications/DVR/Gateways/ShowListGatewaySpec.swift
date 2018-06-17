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
    // swiftlint:disable function_body_length
    override func spec() {
        describe("ShowListGateway") {
            var sut: ShowListGateway!
            
            var request: Request!
            var application: DvrApplication!
            var requestBuilder: DvrRequestBuildingMock!
            var responseParser: DvrResponseParsingMock!
            var requestExecutor: RequestExecutingMock!
            
            beforeEach {
                request = Request(url: "http://myapi/show",
                                  method: .get, parameters: nil)
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                requestBuilder = DvrRequestBuildingMock(application: application)
                requestBuilder.stubs.make = request
                requestExecutor = RequestExecutingMock()
                responseParser = DvrResponseParsingMock()
                responseParser.stubs.parseShows = [DvrShow(identifier: "1", name: "UpdatedShow", quality: "TestQuality")]
                
                sut = ShowListGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
            }
            
            afterEach {
                sut = nil
                
                responseParser = nil
                requestExecutor = nil
                requestBuilder = nil
                application = nil
                request = nil
            }
            
            context("getting shows") {
                var responseData: Data!
                var result: [DvrShow]!
                
                beforeEach {
                    responseData = "stubbed data".data(using: .utf8)
                    requestExecutor.stubs.execute = Observable<Request.Response>.just(
                        Request.Response(data: responseData, statusCode: 200, headers: [:])
                    )
                    
                    // swiftlint:disable force_try
                    result = try! sut
                        .execute()
                        .toBlocking()
                        .first()
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
                
                it("parses the result") {
                    expect(responseParser.captures.parseShows?.storage.data) == responseData
                }
                
                it("returns 1 show") {
                    expect(result.count) == 1
                }
            }
        }
    }
}
