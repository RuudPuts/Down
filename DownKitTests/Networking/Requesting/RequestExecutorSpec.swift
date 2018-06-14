//
//  RequestExecutorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class RequestExecutorSpec: QuickSpec {
    override func spec() {
        describe("RequestExecutor") {
            var sut: RequestExecutor!
            var request: Request!
            
            beforeEach {
                request = Request(url: "https://google.com",
                                  method: .get,
                                  parameters: nil)
                sut = RequestExecutor(request: request)
            }
            
            afterEach {
                sut = nil
                request = nil
            }
        }
    }
}
