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
import Result
import Quick
import Nimble
import RxNimble

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
            
            context("succesfull client execution") {
                var response: Response!
                var result: Observable<Result<Response, DownKitError>>!
                
                beforeEach {
                    request = Request.defaultStub
                    
                    response = Response(data: nil, statusCode: 418, headers: [:])
                    requestClient.stubs.execute.response = response
                    
                    result = sut.execute(request).asObservable()
                }
                
                afterEach {
                    result = nil
                    response = nil
                }
                
                it("sends the response to observable") {
                    expect(result.map { $0.value }).first.to(equal(response))
                }
            }
            
            context("failed client execution") {
                var result: Observable<Result<Response, DownKitError>>!
                var error: DownKitError!
                
                beforeEach {
                    request = Request.defaultStub
                    
                    error = .requestExecuting(.generic(message: "test failure"))
                    requestClient.stubs.execute.error = error
                    
                    result = sut.execute(request).asObservable()
                }
                
                afterEach {
                    result = nil
                    error = nil
                }

                it("sends the error to observable") {
                    expect(result.map { $0.error }).first.to(equal(error))
                }
            }
        }
    }
}
