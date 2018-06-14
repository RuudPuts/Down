//
//  DvrGatewayConfigurationSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class DvrGatewayConfigurationSpec: QuickSpec {
    override func spec() {
        describe("DvrGatewayConfiguration") {
            var sut: DvrGatewayConfiguration<ResponseMapperMock<Any>>!
            
            afterEach {
                sut = nil
            }
            
            context("init without passing request executor factory") {
                beforeEach {
                    sut = DvrGatewayConfiguration(application: ApiApplicationMock(),
                                               responseMapper: ResponseMapperMock())
                }
                
                afterEach {
                    sut = nil
                }
                
                it("initializes default request executor factory") {
                    expect(sut.requestExecutorFactory).to(beAnInstanceOf(RequestExecutorFactory.self))
                }
            }
        }
    }
}
