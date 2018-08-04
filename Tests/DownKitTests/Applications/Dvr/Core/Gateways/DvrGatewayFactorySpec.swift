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
            var application: DvrApplication!
            var additionsFactory: ApplicationAdditionsProducingMock!
            
            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                additionsFactory = ApplicationAdditionsProducingMock()
                sut = DvrGatewayFactory(additionsFactory: additionsFactory)
            }
            
            afterEach {
                application = nil
                sut = nil
            }
            
            context("show list gateway") {
                var gateway: DvrShowListGateway!
                
                beforeEach {
                    gateway = sut.makeShowListGateway(for: application)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    expect(additionsFactory.captures.makeDvrRequestBuilder?.application) === application
                }
            
                it("makes the response parser") {
                    expect(additionsFactory.captures.makeDvrResponseParser?.application) === application
                }
            }
            
            context("show details gateway") {
                var gateway: DvrShowDetailsGateway!
                var show: DvrShow!
                
                beforeEach {
                    show = DvrShow(identifier: "1", name: "show")
                    gateway = sut.makeShowDetailsGateway(for: application, show: show)
                }
                
                afterEach {
                    gateway = nil
                    show = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    expect(additionsFactory.captures.makeDvrRequestBuilder?.application) === application
                }
                
                it("makes the response parser") {
                    expect(additionsFactory.captures.makeDvrResponseParser?.application) === application
                }
                
                it("sets the show") {
                    expect(gateway.show) === show
                }
            }
        }
    }
}
