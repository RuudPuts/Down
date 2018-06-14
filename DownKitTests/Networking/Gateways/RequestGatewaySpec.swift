//
//  RequestGatewaySpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 25/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class RequestGatewaySpec: QuickSpec {
    override func spec() {
        describe("RequestGateway") {
            var sut: RequestGatewayMock!
            var config: RequestGatewayConfiguratingMock!
            
            beforeEach {
                config = RequestGatewayConfiguratingMock()
                
                sut = RequestGatewayMock()
                sut.stubs.config = config
            }
            
            afterEach {
                sut = nil
            }
            
            context("config convenience getters") {
                it("gets the application") {
                    expect(sut.application) === config.application
                }
                
                it("gets the request executor factory") {
                    expect(sut.requestExecutorFactory) === config.requestExecutorFactory
                }
                
                it("gets the response mapper") {
                    expect(sut.responseMapper) === config.responseMapper
                }
            }
            
            context("application convenience getters") {
                it("gets the request builder") {
                    expect(sut.requestBuilder) === config.application.requestBuilder
                }
            }
        }
    }
}
