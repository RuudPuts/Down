//
//  ApiApplicationGatewayFactory.swift
//  DownKitTests
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

//! This test case perfectly shows the problems in the gateway factories
//! Too much duplication

class ApiApplicationGatewayFactorySpec: QuickSpec {
    override func spec() {
        describe("ApiApplicationGatewayFactory") {
            var sut: ApiApplicationGatewayFactory!
            var application: ApiApplicationMock!
            var additionsFactory: ApplicationAdditionsProducingMock!
            
            beforeEach {
                application = ApiApplicationMock()
                additionsFactory = ApplicationAdditionsProducingMock()
                sut = ApiApplicationGatewayFactory(additionsFactory: additionsFactory)
            }
            
            afterEach {
                application = nil
                sut = nil
            }
            
            context("login gateway") {
                var gateway: ApiApplicationLoginGateway!
                
                beforeEach {
                    gateway = sut.makeLoginGateway(for: application, credentials: nil)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    expect(additionsFactory.captures.makeApiApplicationRequestBuilder?.application) === application
                }
            
                it("makes the response parser") {
                    expect(additionsFactory.captures.makeApiApplicationResponseParser?.application) === application
                }
            }
            
            context("apikey gateway") {
                var gateway: ApiApplicationApiKeyGateway!
                
                beforeEach {
                    gateway = sut.makeApiKeyGateway(for: application)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    expect(additionsFactory.captures.makeApiApplicationRequestBuilder?.application) === application
                }
                
                it("makes the response parser") {
                    expect(additionsFactory.captures.makeApiApplicationResponseParser?.application) === application
                }
            }
        }
    }
}
