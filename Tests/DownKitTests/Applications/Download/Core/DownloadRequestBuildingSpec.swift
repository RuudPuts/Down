//
//  DownloadRequestBuildingSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class DownloadRequestBuildingSpec: QuickSpec {
    override func spec() {
        describe("DownloadRequestBuilding") {
            var sut: DownloadRequestBuildingImp!
            var application: DownloadApplication!
            
            beforeEach {
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                sut = DownloadRequestBuildingImp(application: application)
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
                        result = try? sut.make(for: .queue)
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
                        do {
                            result = try sut.make(for: .queue)
                        }
                        catch {
                            // swiftlint:disable force_cast
                            buildError = error as! RequestBuildingError
                        }
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

private class DownloadRequestBuildingImp: DownloadRequestBuilding {
    struct Stubs {
        var defaultParameters: [String: String] = [:]
        var path: String?
        var parameters: [String: String]?
        var method: Request.Method = .get
    }
    
    var stubs = Stubs()
    
    // DvrRequestBuilding
    
    var application: DownloadApplication
    
    required init(application: DownloadApplication) {
        self.application = application
    }
    
    var defaultParameters: [String: String] { return stubs.defaultParameters }
    
    func path(for apiCall: DownloadApplicationCall) -> String? {
        return stubs.path
    }
    
    func parameters(for apiCall: DownloadApplicationCall) -> [String: String]? {
        return stubs.parameters
    }
    
    func method(for apiCall: DownloadApplicationCall) -> Request.Method {
        return stubs.method
    }
}
