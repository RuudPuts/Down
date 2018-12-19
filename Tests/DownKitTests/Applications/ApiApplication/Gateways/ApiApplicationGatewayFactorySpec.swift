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

class ApiApplicationGatewayFactorySpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("ApiApplicationGatewayFactory") {
            var sut: ApiApplicationGatewayFactory!
            var application: ApiApplicationMock!
            var dependenciesStub: DownKitDependenciesStub!
            
            beforeEach {
                application = ApiApplicationMock()
                dependenciesStub = DownKitDependenciesStub()
                sut = ApiApplicationGatewayFactory(dependencies: dependenciesStub)
            }
            
            afterEach {
                application = nil
                dependenciesStub = nil
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
                    expect(dependenciesStub.applicationAdditionsFactoryMock.captures.makeApiApplicationRequestBuilder?.application) === application
                }
            
                it("makes the response parser") {
                    expect(dependenciesStub.applicationAdditionsFactoryMock.captures.makeApiApplicationResponseParser?.application) === application
                }
            }
            
            context("apikey gateway") {
                var gateway: ApiApplicationApiKeyGateway!
                
                beforeEach {
                    gateway = sut.makeApiKeyGateway(for: application, credentials: nil)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    expect(dependenciesStub.applicationAdditionsFactoryMock.captures.makeApiApplicationRequestBuilder?.application) === application
                }
                
                it("makes the response parser") {
                    expect(dependenciesStub.applicationAdditionsFactoryMock.captures.makeApiApplicationResponseParser?.application) === application
                }
            }
        }
    }
}
