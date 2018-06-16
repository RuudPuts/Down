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
            var sut: DvrRequestBuildingImp!
            var application: DvrApplicationMock!
            
            beforeEach {
                application = DvrApplicationMock()
                sut = DvrRequestBuildingImp(application: application)
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
                        result = try? sut.make(for: .showList)
                    }
                    
                    it("sets the url") {
                        expect(result.url) == "\(application.host)/api/mycall"
                    }
                    
                    it("sets the method") {
                        expect(result.method) == .get
                    }
                }
                
                context("from invalid builder data") {
                    var buildError: RequestBuildingError!
                    
                    beforeEach {
                        do { result = try sut.make(for: .showList) }
                        catch { buildError = error as! RequestBuildingError}
                    }
                    
                    it("does not make the request") {
                        expect(result).to(beNil())
                    }
                    
                    it("throws not supported error") {
                        expect(buildError) == RequestBuildingError.notSupportedError("")
                    }
                }
            }
        }
    }
}

private class DvrRequestBuildingImp : DvrRequestBuilding {
    struct Stubs {
        var defaultParameters: [String: String]?
        var path: String?
        var parameters: [String: String]?
        var method: Request.Method = .get
    }
    
    var stubs = Stubs()
    
    // DvrRequestBuilding
    
    var application: DvrApplication
    
    required init(application: DvrApplication) {
        self.application = application
    }
    
    var defaultParameters: [String : String]? { return stubs.defaultParameters }
    
    func path(for apiCall: DvrApplicationCall) -> String? {
        return stubs.path
    }
    
    func parameters(for apiCall: DvrApplicationCall) -> [String : String]? {
        return stubs.parameters
    }
    
    func method(for apiCall: DvrApplicationCall) -> Request.Method {
        return stubs.method
    }
}
