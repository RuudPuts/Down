//
//  DownloadGatewayFactory.swift
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

class DownloadGatewayFactorySpec: QuickSpec {
    override func spec() {
        describe("DownloadGatewayFactory") {
            var sut: DownloadGatewayFactory!
            var application: DownloadApplication!
            var additionsFactory: ApplicationAdditionsProducingMock!
            
            beforeEach {
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                additionsFactory = ApplicationAdditionsProducingMock()
                sut = DownloadGatewayFactory(additionsFactory: additionsFactory)
            }
            
            afterEach {
                application = nil
                sut = nil
            }
            
            context("queue gateway") {
                var gateway: DownloadQueueGateway!
                
                beforeEach {
                    gateway = sut.makeQueueGateway(for: application)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    expect(additionsFactory.captures.makeDownloadRequestBuilder?.application) === application
                }
            
                it("makes the response parser") {
                    expect(additionsFactory.captures.makeDownloadResponseParser?.application) === application
                }
            }
            
            context("history gateway") {
                var gateway: DownloadHistoryGateway!
                
                beforeEach {
                    gateway = sut.makeHistoryGateway(for: application)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    expect(additionsFactory.captures.makeDownloadRequestBuilder?.application) === application
                }
                
                it("makes the response parser") {
                    expect(additionsFactory.captures.makeDownloadResponseParser?.application) === application
                }
            }
        }
    }
}
