//
//  SickbeardApplicationSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class SickbeardApplicationSpec: QuickSpec {
    override func spec() {
        describe("SickbeardApplication") {
            var sut: SickbeardApplication!
            
            beforeEach {
                sut = SickbeardApplication(host: "SickbeardHost", apiKey: "SickbeardApiKey")
            }
            
            afterEach {
                sut = nil
            }
            
            it("sets the application name") {
                expect(sut.name) == "Sickbeard"
            }
            
            it("sets the request builder") {
                expect(sut.dvrRequestBuilder.application) === sut
            }
            
            it("sets the response parser") {
                expect(sut.responseParser).to(beAnInstanceOf(SickbeardResponseParser.self))
            }
        }
    }
}
