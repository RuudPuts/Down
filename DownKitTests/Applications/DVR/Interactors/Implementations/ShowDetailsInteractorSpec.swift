//
//  ShowDetailsInteractorSpec.swift
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

class ShowDetailsInteractorSpec: QuickSpec {
    override func spec() {
        describe("ShowDetailsInteractor") {
            var sut: ShowDetailsInteractor!
            var gateway: ShowDetailsGateway!
            
            var application: DvrApplication!
            var builder: DvrRequestBuildingMock!
            var parser: DvrResponseParsingMock!
            var executor: RequestExecutingMock!
                
            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                builder = DvrRequestBuildingMock(application: application)
                parser = DvrResponseParsingMock()
                executor = RequestExecutingMock()
                
                gateway = ShowDetailsGateway(builder: builder,
                                             parser: parser,
                                             executor: executor)
                sut = ShowDetailsInteractor(gateway: gateway)
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
                    show = DvrShow(identifier: "1234", name: "TextShow", quality: "Awesome")
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
