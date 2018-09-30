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
            
            var application: DownloadApplication!
            var requestBuilder: DownloadRequestBuildingMock!
            var responseParser: DownloadResponseParsingMock!
            var requestExecutor: RequestExecutingMock!
            
            beforeEach {
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                requestBuilder = DownloadRequestBuildingMock(application: application)
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
            }

            describe("making the request") {
                var request: Request!
                var result: Request!

                beforeEach {
                    request = Request(url: "http://myapi/queue", method: .get)
                    requestBuilder.stubs.make = request
                    result = try? sut.makeRequest()
                }

                afterEach {
                    result = nil
                    request = nil
                }

                it("builds the queue request") {
                    expect(requestBuilder.captures.make?.call) == DownloadApplicationCall.queue
                }

                it("returns the request") {
                    expect(result) === request
                }
            }

            describe("parsing the response") {
                var response: Response!
                var queue: DownloadQueue!
                var result: DownloadQueue!

                beforeEach {
                    response = Response(data: Data(), statusCode: 200, headers: [:])

                    queue = DownloadQueue(speedMb: 0, remainingTime: 0, remainingMb: 0, items: [])
                    responseParser.stubs.parseQueue = queue

                    result = try! sut.parse(response: response)
                }

                afterEach {
                    result = nil
                    queue = nil
                    response = nil
                }

                it("parses the queue") {
                    expect(responseParser.captures.parseQueue?.response.data) == Data()
                }

                it("returns the queue") {
                    expect(result) === queue
                }
            }
        }
    }
}
