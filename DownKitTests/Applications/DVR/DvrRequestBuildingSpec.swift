//
//  DvrRequestBuildingSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

@testable import DownKit
import Quick
import Nimble

class DvrRequestBuildingSpec: QuickSpec {
    override func spec() {
        describe("DvrRequestBuilding") {
            var sut: DvrRequestBuildingMock!
            var application: DvrApplicationMock!
            
            beforeEach {
                application = DvrApplicationMock()
                sut = DvrRequestBuildingMock(application: application)
            }
            
            afterEach {
                application = nil
                sut = nil
            }
            
            context("make request") {
                var result: Request!
                
                afterEach {
                    result = nil
                }
                
                context("from valid builder data") {
                    beforeEach {
                        sut.stubs.path = "api/mycall"
                        result = sut.make(for: .showList)
                    }
                    
                    it("sets the url") {
                        expect(result.url) == "\(application.host)/api/mycall"
                    }
                    
                    it("sets the method") {
                        expect(result.method) == .get
                    }
                }
                
                context("from invalid builder data") {
                    beforeEach {
                        result = sut.make(for: .showList)
                    }
                    
                    it("does not make the request") {
                        expect(result).to(beNil())
                    }
                }
            }
        }
    }
}
