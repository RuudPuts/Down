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
            var application: DvrApplicationMock!
            var gateway: ShowListGatewayMock!
            var gatewayConfig: ShowListGateway.Config!
            
            beforeEach {
                application = DvrApplicationMock()
                gatewayConfig = ShowListGateway.Config(application: application,
                                                       responseMapper: DvrShowsResponseMapper(parser: ResponseParsingMock()),
                                                       requestExecutorFactory: RequestExecutorProducingMock())
                gateway = ShowListGatewayMock(config: gatewayConfig)
                sut = ShowListInteractor(application: application,
                                         gateway: gateway)
            }
            
            afterEach {
                sut = nil
                gatewayConfig = nil
                application = nil
            }
            
            context("observing") {
//                var observer: Observable<[DvrShow]>!
//                
//                beforeEach {
//                    observer = sut.asObservable()
//                }
//                
//                afterEach {
//                    observer = nil
//                }
            }
        }
    }
}

class ShowListGatewayMock: ShowListGateway {
    struct Stubs {
        
    }
    
    var stubs = Stubs()
}
