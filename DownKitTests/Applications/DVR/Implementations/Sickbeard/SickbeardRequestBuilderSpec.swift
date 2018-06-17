//
//  SickbeardRequestBuilderSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class SickbeardRequestBuilderSpec: QuickSpec {
    var sut: SickbeardRequestBuilder!
    
    override func spec() {
        describe("SickbeardRequestBuilder") {
            var application: DvrApplication!
            
            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                self.sut = SickbeardRequestBuilder(application: application)
            }
            
            afterEach {
                self.sut = nil
            }
            
            it("build default paramters") {
                expect(self.sut.defaultParameters) == ["apikey": application.apiKey]
            }
            
            context("build showList call") {
                test(call: .showList, toBuildPath: "api/{apikey}?cmd=shows", parameters: nil, method: .get)
            }
            
            context("build showDetails call") {
                var show: DvrShow! = DvrShow(identifier: "0", name: "TestShow", quality: "TestQuality")
                test(call: .showDetails(show),
                     toBuildPath: "api/{apikey}?cmd=show.seasons%7Cshow&tvdbid={id}",
                     parameters: ["id": show.identifier], method: .get)
                show = nil
            }
        }
    }
    
    func test(call: DvrApplicationCall, toBuildPath expectedPath: String, parameters expectedParameters: [String: String]?, method expectedMethod: Request.Method) {
        it("returns the expected path") {
            expect(self.sut.path(for: call)) == expectedPath
        }
        
        it("returns the expected parameters") {
            if let params = expectedParameters {
                expect(self.sut.parameters(for: call)) == params
            }
            else {
                expect(self.sut.parameters(for: call)).to(beNil())
            }
        }
        
        it("returns the expected method") {
            expect(self.sut.method(for: call)) == expectedMethod
        }
    }
}
