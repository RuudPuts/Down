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
            
            var application: DownloadApplication!
            var requestBuilder: DownloadRequestBuildingMock!
            var responseParser: DownloadResponseParsingMock!
            var requestExecutor: RequestExecutingMock!
            
            beforeEach {
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                requestBuilder = DownloadRequestBuildingMock(application: application)
                requestExecutor = RequestExecutingMock()
                responseParser = DownloadResponseParsingMock()
                
                sut = DownloadHistoryGateway(builder: requestBuilder, parser: responseParser, executor: requestExecutor)
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

                it("builds the history request") {
                    expect(requestBuilder.captures.make?.call) == DownloadApplicationCall.history
                }

                it("returns the request") {
                    expect(result) === request
                }
            }

            describe("parsing the response") {
                var response: Response!
                var historyItems: [DownloadItem]!
                var result: [DownloadItem]!

                beforeEach {
                    response = Response(data: Data(), statusCode: 200, headers: [:])

                    historyItems = [DownloadItem(identifier: "1", name: "QueueItem", category: "", sizeMb: 0, progress: 0)]
                    responseParser.stubs.parseHistory = historyItems

                    result = try? sut.parse(response: response)
                }

                afterEach {
                    result = nil
                    historyItems = nil
                    response = nil
                }

                it("parses the history") {
                    expect(responseParser.captures.parseHistory?.response.data) == Data()
                }

                it("returns the history") {
                    expect(result) === historyItems
                }
            }
        }
    }
    // swiftlint:enable function_body_length
}
