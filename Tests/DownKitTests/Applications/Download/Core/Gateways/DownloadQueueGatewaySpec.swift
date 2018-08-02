//
//  DownloadQueueGatewaySpec.swift
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

class DownloadQueueGatewaySpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("DownloadQueueGateway") {
            var sut: DownloadQueueGateway!
            
            var request: Request!
            var application: DownloadApplication!
            var requestBuilder: DownloadRequestBuildingMock!
            var responseParser: DownloadResponseParsingMock!
            var requestExecutor: RequestExecutingMock!
            
            beforeEach {
                request = Request(url: "http://myapi/show",
                                  method: .get)
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                requestBuilder = DownloadRequestBuildingMock(application: application)
                requestBuilder.stubs.make = request
                requestExecutor = RequestExecutingMock()
                responseParser = DownloadResponseParsingMock()
                
                sut = DownloadQueueGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
            }
            
            afterEach {
                sut = nil
                
                responseParser = nil
                requestExecutor = nil
                requestBuilder = nil
                application = nil
                request = nil
            }
            
            context("fetching queue") {
                var responseData: Data!
                var result: DownloadQueue!
                
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
                
                it("builds the queue request") {
                    expect(requestBuilder.captures.make?.call) == DownloadApplicationCall.queue
                }
                
                it("executes the request") {
                    expect(requestExecutor.captures.execute?.request) == request
                }
                
                it("parses the queue") {
                    expect(responseParser.captures.parseQueue?.response.data) == responseData
                }
                
                it("returns the queue") {
                    expect(result).toNot(beNil())
                }
            }
        }
    }
}
