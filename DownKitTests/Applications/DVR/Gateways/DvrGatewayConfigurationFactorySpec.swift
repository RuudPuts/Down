//
//  DvrGatewayConfigurationFactorySpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class DvrGatewayConfigurationFactorySpec: QuickSpec {
    override func spec() {
        describe("DvrGatewayConfigurationFactory") {
            var sut: DvrGatewayConfigurationFactory!
            
            var application: DvrApplicationMock!
            var responseParser: DvrResponseParsing!
            
            beforeEach {
                responseParser = DvrResponseParsingMock()
                
                application = DvrApplicationMock()
                application.stubs.responseParser = responseParser
                
                sut = DvrGatewayConfigurationFactory(application: application)
            }
            
            afterEach {
                sut = nil
            }
            
            context("make configuration with mapper") {
                var result: DvrGatewayConfiguration<AnyDvrResponseMapper>!
                
                beforeEach {
                    result = sut.make()
                }
                
                afterEach {
                    result = nil
                }
                
                it("sets the application") {
                    expect(result.application) === application
                }
                
                it("creates the response mapper with the application's parser") {
                    expect(result.responseMapper.dvrParser) === responseParser
                }
            }
        }
    }
}

private class AnyDvrResponseMapper: DvrResponseMapper {
    typealias ResultType = Any
    var parser: ResponseParsing
    
    required init(parser: ResponseParsing) {
        self.parser = parser
    }
    
    func map(storage: DataStoring) -> Any {
        return ""
    }
}
