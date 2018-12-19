//
//  DvrShowDetailsInteractorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

//ShowDetailsInteractor

@testable import DownKit
import RxSwift
import Quick
import Nimble

class DvrShowDetailsInteractorSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("DvrShowDetailsInteractor") {
            var sut: DvrShowDetailsInteractor!
            var gateway: DvrShowDetailsGateway!
            
            var application: DvrApplication!
            var builder: DvrRequestBuildingMock!
            var parser: DvrResponseParsingMock!
            var executor: RequestExecutingMock!
                
            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                builder = DvrRequestBuildingMock(application: application)
                parser = DvrResponseParsingMock()
                executor = RequestExecutingMock()
                
                gateway = DvrShowDetailsGateway(builder: builder,
                                             parser: parser,
                                             executor: executor)
                sut = DvrShowDetailsInteractor(gateway: gateway)
            }
            
            afterEach {
                sut = nil
                gateway = nil
                
                application = nil
                builder = nil
                parser = nil
                executor = nil
            }
            
            context("setting show") {
                var show: DvrShow!
                
                beforeEach {
                    builder.stubs.make = Request.defaultStub
                    show = DvrShow(identifier: "1234", name: "TextShow")
                    _ = sut.setShow(show)
                }
                
                afterEach {
                    show = nil
                }
                
                it("set the show on the gateway") {
                    expect(gateway.show) === show
                }
            }
        }
    }
}
