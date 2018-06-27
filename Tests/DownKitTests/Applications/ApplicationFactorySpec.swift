//
//  ApplicationFactorySpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class ApplicationFactorySpec: QuickSpec {
    override func spec() {
        describe("ApplicationFactory") {
            var sut: ApplicationFactory!
            
            beforeEach {
                sut = ApplicationFactory()
            }
            
            afterEach {
                sut = nil
            }
            
            context("dvr applications") {
                var application: DvrApplication!
                
                afterEach {
                    application = nil
                }
                
                context("sickbeard") {
                    beforeEach {
                        application = sut.makeDvr(type: .sickbeard)
                    }
                    
                    it("makes the application") {
                        expect(application.dvrType) == .sickbeard
                    }
                }
            }
        }
    }
}
