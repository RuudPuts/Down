//
//  DvrShowDetailsResponseMapperSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 28/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class DvrShowDetailsResponseMapperSpec: QuickSpec {
    override func spec() {
        describe("DvrShowDetailsResponseMapper") {
            var sut: DvrShowDetailsResponseMapper!
            var mockParser: DvrResponseParserMock!
            
            beforeEach {
                mockParser = DvrResponseParserMock()
                sut = DvrShowDetailsResponseMapper(parser: mockParser)
            }
            
            afterEach {
                sut = nil
                mockParser = nil
            }
            
            context("mapping data storage") {
                var DataStoring: DataStoringMock!
                
                beforeEach {
                    DataStoring = DataStoringMock()
                    _ = sut.map(storage: DataStoring)
                }
                
                afterEach {
                    DataStoring = nil
                }
                
                it("parses data storage") {
                    expect(mockParser.captures.parseShow?.storage) === DataStoring
                }
            }
        }
    }
}
