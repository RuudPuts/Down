//
//  DvrShowSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class DvrShowSpec: QuickSpec {
    override func spec() {
        describe("DvrShow") {
            var sut: DvrShow!
            var database: DvrDatabaseMock!
            
            afterEach {
                database = nil
                sut = nil
            }
            
            context("complete show") {
                beforeEach {
                    sut = DvrShow(identifier: "78804",
                                  name: "Doctor Who (2005)")
                }
                
                it("is not partial") {
                    expect(sut.isPartial) == false
                }
                
                context("database storing") {
                    beforeEach {
                        database = DvrDatabaseMock()
                        
                        sut.store(in: database)
                    }
                    
                    it("stores itself") {
                        expect(database.captures.storeShow?.show) === sut
                    }
                }
            }
            
            context("incomplete show") {
                beforeEach {
                    sut = DvrShow(identifier: DvrShow.partialIdentifier,
                                  name: "Doctor Who (2005)")
                }
                
                it("is partial") {
                    expect(sut.isPartial) == true
                }
                
                context("database storing") {
                    beforeEach {
                        database = DvrDatabaseMock()
                        
                        sut.store(in: database)
                    }
                    
                    it("stores won't store anything") {
                        expect(database.captures.storeShow).to(beNil())
                    }
                }
            }
        }
    }
}
