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
            
            beforeEach {
                sut = Request(url: "https://google.com", method: .get, parameters: nil)
            }
            
            afterEach {
                sut = nil
            }
            
            context("convert to URLRequest") {
                var urlRequest: URLRequest?
                
                beforeEach {
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
            }
        }
    }
}
