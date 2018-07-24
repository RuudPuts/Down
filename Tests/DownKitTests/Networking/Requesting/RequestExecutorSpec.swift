//
//  RequestExecutorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import RxBlocking
import Quick
import Nimble

class RequestExecutorSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("RequestExecutor") {
            var sut: RequestExecutor!
            var request: Request!
            var requestClient: RequestClientMock!
            
            beforeEach {
                requestClient = RequestClientMock()
                sut = RequestExecutor(requestClient: requestClient)
            }
            
            afterEach {
                sut = nil
                request = nil
                requestClient = nil
            }
            
            context("execute invalid request") {
                var result: MaterializedSequenceResult<Response>!
                
                beforeEach {
                    request = Request(url: "some invalid url", method: .get)
                    sut = RequestExecutor()
                    
                    result = sut
                        .execute(request)
                        .toBlocking()
                        .materialize()
                }
                
                afterEach {
                    result = nil
                }
                
                it("throws invalid request error") {
                    expect(result.error as? RequestClientError) == .invalidRequest
                }
            }
            
            context("succesfull client execution") {
                var response: Response!
                var result: Response!
                
                beforeEach {
                    request = Request(url: "https://google.com", method: .get)
                    
                    response = Response(data: nil, statusCode: 418, headers: [:])
                    requestClient.stubs.execute.willDo = { _, completionHandler in
                        completionHandler(response, nil)
                    }
                    
                    // swiftlint:disable force_try
                    result = try! sut.execute(request)
                        .toBlocking()
                        .first()
                }
                
                afterEach {
                    response = nil
                }
                
                it("sends response to observable") {
                    expect(result) === response
                }
            }
            
            context("failed client execution") {
                var result: MaterializedSequenceResult<Response>!
                var failure: RequestClientError!
                
                beforeEach {
                    request = Request(url: "https://google.com", method: .get)
                    
                    failure = .generic(message: "test failure")
                    requestClient.stubs.execute.willDo = { _, completionHandler in
                        completionHandler(nil, failure)
                    }
                    
                    result = sut
                        .execute(request)
                        .toBlocking()
                        .materialize()
                }
                
                afterEach {
                    result = nil
                    failure = nil
                }
                
                it("sends error to observable") {
                    expect(result.error as? RequestClientError) == failure
                }
            }
        }
    }
}

extension HTTPURLResponse {
    static func from(_ request: Request, and response: Response) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: request.url)!,
            statusCode: response.statusCode,
            httpVersion: nil,
            headerFields: response.headers
        )!
    }
}
