//
//  DownloadHistoryGatewaySpec.swift
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

class DownloadHistoryGatewaySpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("DownloadHistoryGateway") {
            var sut: DownloadHistoryGateway!
            
            var request: Request!
            var application: DownloadApplication!
            var requestBuilder: DownloadRequestBuildingMock!
            var responseParser: DownloadResponseParsingMock!
            var requestExecutor: RequestExecutingMock!
            
            beforeEach {
                request = Request(url: "http://myapi/show", method: .get)
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                requestBuilder = DownloadRequestBuildingMock(application: application)
                requestBuilder.stubs.make = request
                requestExecutor = RequestExecutingMock()
                responseParser = DownloadResponseParsingMock()
                responseParser.stubs.parseHistory = [DownloadItem(identifier: "1", name: "QueueItem")]
                
                sut = DownloadHistoryGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
            }
            
            afterEach {
                sut = nil
                
                responseParser = nil
                requestExecutor = nil
                requestBuilder = nil
                application = nil
                request = nil
            }
            
            context("fetching history") {
                var responseData: Data!
                var result: [DownloadItem]!
                
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
                
                it("builds the history request") {
                    expect(requestBuilder.captures.make?.call) == DownloadApplicationCall.history
                }
                
                it("executes the request") {
                    expect(requestExecutor.captures.execute?.request) == request
                }
                
                it("parses the history") {
                    expect(responseParser.captures.parseHistory?.response.data) == responseData
                }
                
                it("returns the items") {
                    expect(result).toNot(beNil())
                }
            }
        }
    }
}
