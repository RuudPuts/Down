//
//  RequestSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 19/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class RequestSpec: QuickSpec {
    override func spec() { 
        describe("Request") {
            var sut: Request!
            
            afterEach {
                sut = nil
            }
            
            context("initialize with host, path, parameters and default parameters") {
                beforeEach {
                    sut = Request(host: "http://myapi.com",
                                  path: "{command}?apikey={apikey}",
                                  method: .get,
                                  defaultParameters: ["apikey": "testkey"],
                                  parameters: ["command": "testcommand"])
                }
                
                it("stores the url") {
                    expect(sut.url) == "http://myapi.com/testcommand?apikey=testkey"
                }
            }
            
            context("convert to URLRequest") {
                var urlRequest: URLRequest?
                
                beforeEach {
                    sut = Request(url: "https://google.com", method: .get, parameters: nil)
                    urlRequest = sut.asUrlRequest()
                }
                
                afterEach {
                    urlRequest = nil
                }
                
                it("creates and urlRequest") {
                    expect(urlRequest).toNot(beNil())
                }
                
                it("sets the url") {
                    expect(urlRequest?.url?.absoluteString) == sut.url
                }
                
                it("sets the request method") {
                    expect(urlRequest?.httpMethod?.lowercased()) == sut.method.rawValue
                }
                
                context("request with invalid parameters") {
                    beforeEach {
                        sut = Request(url: "invalid url", method: .get, parameters: nil)
                        urlRequest = sut.asUrlRequest()
                    }
                    
                    afterEach {
                        urlRequest = nil
                    }
                    
                    it("fails") {
                        expect(urlRequest).to(beNil())
                    }
                }
            }
        }
    }
}
