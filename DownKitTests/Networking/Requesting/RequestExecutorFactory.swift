//
//  RequestExecutorFactory.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class RequestExecutorFactorySpec: QuickSpec {
    override func spec() {
        describe("RequestExecutorFactory") {
            var sut: RequestExecutorFactory!
            
            beforeEach {
                sut = RequestExecutorFactory()
            }
            
            afterEach {
                sut = nil
            }
            
            context("make request executing") {
                var result: RequestExecuting!
                var request: Request!
                
                beforeEach {
                    request = Request(url: "https://google.com",
                                      method: .get,
                                      parameters: nil)
                    
                    result = sut.make(for: request)
                }
                
                afterEach {
                    sut = nil
                    request = nil
                }
                
                it("sets the request") {
                    expect(result.request) == request
                }
            }
        }
    }
}
