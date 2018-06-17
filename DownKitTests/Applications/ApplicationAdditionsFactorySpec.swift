//
//  ApplicationAdditionsFactorySpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class ApplicationAdditionsFactorySpec: QuickSpec {
    override func spec() {
        describe("ApplicationAdditionsFactory") {
            var sut: ApplicationAdditionsFactory!
            
            beforeEach {
                sut = ApplicationAdditionsFactory()
            }
            
            afterEach {
                sut = nil
            }
            
            context("dvr applications") {
                var application: DvrApplication!
                
                beforeEach {
                    application = DvrApplication(type: .sickbeard, host: "", apiKey: "")
                }
                
                afterEach {
                    application = nil
                }
                
                context("request builder") {
                    var requistBuilder: DvrRequestBuilding!
                    
                    afterEach {
                        requistBuilder = nil
                    }
                    
                    context("sickbeard") {
                        beforeEach {
                            requistBuilder = sut.makeDvrRequestBuilder(for: application)
                        }
                        
                        it("makes the builder") {
                            expect(requistBuilder).to(beAKindOf(SickbeardRequestBuilder.self))
                        }
                    }
                }
                
                context("response parser") {
                    var responseParser: DvrResponseParsing!
                    
                    afterEach {
                        responseParser = nil
                    }
                    
                    context("sickbeard") {
                        beforeEach {
                            responseParser = sut.makeDvrResponseParser(for: application)
                        }
                        
                        it("makes the parser") {
                            expect(responseParser).to(beAKindOf(SickbeardResponseParser.self))
                        }
                    }
                }
            }
        }
    }
}
