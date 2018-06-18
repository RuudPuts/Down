//
//  ShowListInteractorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import Quick
import Nimble

class ShowListInteractorSpec: QuickSpec {
    override func spec() {
        describe("ShowListInteractor") {
            var sut: ShowListInteractor!
            var application: DvrApplication!
            var gateway: ShowListGatewayMock!
            
            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                gateway = ShowListGatewayMock(builder: DvrRequestBuildingMock(application: application),
                                              parser: DvrResponseParsingMock(),
                                              executor: RequestExecutingMock())
                sut = ShowListInteractor(gateway: gateway)
            }
            
            afterEach {
                sut = nil
                application = nil
            }
            
            context("observing") {
                beforeEach {
                    _ = sut.observe()
                }
            }
        }
    }
}

class ShowListGatewayMock: ShowListGateway {
    struct Stubs {
        
    }
    
    var stubs = Stubs()
}
