//
//  RequestGatewayInteractorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import Quick
import Nimble
import RxNimble

class RequestGatewayInteractorSpec: QuickSpec {
    override func spec() {
        describe("RequestGatewayInteractor") {
            var sut: RequestGatewayInteractor<RequestGatewayMock>!
            var gateway: RequestGatewayMock!
            
            beforeEach {
                gateway = RequestGatewayMock()
                gateway.stubs.observe = Observable.just(0)
                sut = RequestGatewayInteractor(gateway: gateway)
            }
            
            afterEach {
                sut = nil
                gateway = nil
            }
            
            context("observing") {
                var result: Observable<Int>!

                beforeEach {
                    result = sut.observe().map { $0 as! Int }
                }
                
                afterEach {
                    result = nil
                }
                
                it("executes the gateway") {
                    expect(result).first == 0
                }
            }
        }
    }
}
