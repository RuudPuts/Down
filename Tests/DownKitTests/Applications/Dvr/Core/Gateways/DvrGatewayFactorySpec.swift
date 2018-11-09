//
//  DvrGatewayFactorySpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class DvrGatewayFactorySpec: QuickSpec {
    override func spec() {
        describe("DvrGatewayFactory") {
            var sut: DvrGatewayFactory!
            var dependenciesStub: DownKitDependenciesStub!
            
            beforeEach {
                dependenciesStub = DownKitDependenciesStub()
                sut = DvrGatewayFactory(dependencies: dependenciesStub)
            }
            
            afterEach {
                dependenciesStub = nil
                sut = nil
            }
            
            context("show list gateway") {
                var gateway: DvrShowListGateway!
                
                beforeEach {
                    gateway = sut.makeShowListGateway(for: dependenciesStub.dvrApplication)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    let capturedApplication = dependenciesStub.applicationAdditionsFactoryMock.captures.makeDvrRequestBuilder?.application
                    expect(capturedApplication) === dependenciesStub.dvrApplication
                }
            
                it("makes the response parser") {
                    let capturedApplication = dependenciesStub.applicationAdditionsFactoryMock.captures.makeDvrResponseParser?.application
                    expect(capturedApplication) === dependenciesStub.dvrApplication
                }
            }
            
            context("show details gateway") {
                var gateway: DvrShowDetailsGateway!
                var show: DvrShow!
                
                beforeEach {
                    show = DvrShow(identifier: "1", name: "show")
                    gateway = sut.makeShowDetailsGateway(for: dependenciesStub.dvrApplication, show: show)
                }
                
                afterEach {
                    gateway = nil
                    show = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }

                it("makes the request builder") {
                    let capturedApplication = dependenciesStub.applicationAdditionsFactoryMock.captures.makeDvrRequestBuilder?.application
                    expect(capturedApplication) === dependenciesStub.dvrApplication
                }

                it("makes the response parser") {
                    let capturedApplication = dependenciesStub.applicationAdditionsFactoryMock.captures.makeDvrResponseParser?.application
                    expect(capturedApplication) === dependenciesStub.dvrApplication
                }
                
                it("sets the show") {
                    expect(gateway.show) === show
                }
            }
        }
    }
}
