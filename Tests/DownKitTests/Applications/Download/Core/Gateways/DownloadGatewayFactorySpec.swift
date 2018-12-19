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

class DownloadGatewayFactorySpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("DownloadGatewayFactory") {
            var sut: DownloadGatewayFactory!
            var dependenciesStub: DownKitDependenciesStub!
            
            beforeEach {
                dependenciesStub = DownKitDependenciesStub()
                sut = DownloadGatewayFactory(dependencies: dependenciesStub)
            }
            
            afterEach {
                dependenciesStub = nil
                sut = nil
            }
            
            context("queue gateway") {
                var gateway: DownloadQueueGateway!
                
                beforeEach {
                    gateway = sut.makeQueueGateway(for: dependenciesStub.downloadApplication)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    let capturedApplication = dependenciesStub.applicationAdditionsFactoryMock.captures.makeDownloadRequestBuilder?.application
                    expect(capturedApplication) === dependenciesStub.downloadApplication
                }
            
                it("makes the response parser") {
                    let capturedApplication = dependenciesStub.applicationAdditionsFactoryMock.captures.makeDownloadResponseParser?.application
                    expect(capturedApplication) === dependenciesStub.downloadApplication
                }
            }
            
            context("history gateway") {
                var gateway: DownloadHistoryGateway!
                
                beforeEach {
                    gateway = sut.makeHistoryGateway(for: dependenciesStub.downloadApplication)
                }
                
                afterEach {
                    gateway = nil
                }
                
                it("makes the gateway") {
                    expect(gateway).toNot(beNil())
                }
                
                it("makes the request builder") {
                    let capturedApplication = dependenciesStub.applicationAdditionsFactoryMock.captures.makeDownloadRequestBuilder?.application
                    expect(capturedApplication) === dependenciesStub.downloadApplication
                }
                
                it("makes the response parser") {
                    let capturedApplication = dependenciesStub.applicationAdditionsFactoryMock.captures.makeDownloadResponseParser?.application
                    expect(capturedApplication) === dependenciesStub.downloadApplication
                }
            }
        }
    }
}
