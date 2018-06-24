//
//  SabNZBdRequestBuilderSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class SabNZBdRequestBuilderSpec: QuickSpec {
    var sut: SabNZBdRequestBuilder!
    
    override func spec() {
        describe("SabNZBdRequestBuilder") {
            var application: DownloadApplication!
            
            beforeEach {
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                self.sut = SabNZBdRequestBuilder(application: application)
            }
            
            afterEach {
                self.sut = nil
            }
            
            it("build default paramters") {
                expect(self.sut.defaultParameters) == ["apikey": application.apiKey]
            }
            
            context("build queue call") {
                test(call: .queue, toBuildPath: "api?mode=queue&output=json&apikey={apikey}", parameters: nil, method: .get)
            }
            
            context("build history call") {
                test(call: .history, toBuildPath: "api?mode=history&output=json&apikey={apikey}", parameters: nil, method: .get)
            }
        }
    }
    
    func test(call: DownloadApplicationCall, toBuildPath expectedPath: String, parameters expectedParameters: [String: String]?, method expectedMethod: Request.Method) {
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
