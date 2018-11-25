//
//  SabNZBdResponseParserSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble
import RealmSwift
import SwiftyJSON
import Result

class SabNZBdResponseParserSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("SabNZBdResponseParser") {
            var sut: SabNZBdResponseParser!
            var response: Response!
            
            beforeEach {
                sut = SabNZBdResponseParser(application: ApiApplicationMock())
                response = Response.defaultStub
            }
            
            afterEach {
                response = nil
                sut = nil
            }
            
            context("parse Response") {
                var result: Result<JSON, DownKitError>!
                
                afterEach {
                    result = nil
                }
                
                context("without data") {
                    beforeEach {
                        result = sut.parse(response, forKey: .queue)
                    }
                    
                    it("throws no data error") {
                        expect(result.error) == .responseParsing(.noData)
                    }
                }
                
                context("from succesful response") {
                    beforeEach {
                        response.data = Data(fromJsonFile: "sabnzbd_success")
                        result = sut.parse(response, forKey: .queue)
                    }

                    it("parses the json's data") {
                        expect(result.value) == ["version": "2.0.0"]
                    }
                }

                context("from failure response") {
                    beforeEach {
                        response.data = Data(fromJsonFile: "sabnzbd_error")
                        result = sut.parse(response, forKey: .queue)
                    }

                    it("throws api error") {
                        expect(result.error) == .responseParsing(.api(message: "not implemented"))
                    }
                }

                context("from invalid response") {
                    beforeEach {
                        response.data = "invalid response".data(using: .utf8)
                        result = sut.parse(response, forKey: .queue)
                    }

                    it("throws invalid json error") {
                        expect(result.error) == .responseParsing(.invalidJson)
                    }
                }
            }

            describe("parse queue Response") {
                var result: DownloadQueue!

                beforeEach {
                    response.data = Data(fromJsonFile: "sabnzbd_queue")
                    result = sut.parseQueue(from: response).value
                }

                afterEach {
                    result = nil
                }

                it("parses current speed") {
                    expect(result.speedMb) == 31.7
                }

                it("parses time remaining") {
                    expect(result.remainingTime) == 3855
                }

                it("parses current data remaining") {
                    expect(result.remainingMb) == 487.70
                }

                it("parses 1 item") {
                    expect(result.items.count) == 1
                }
            }

            describe("parse history Response") {
                var result: [DownloadItem]!

                beforeEach {
                    response.data = Data(fromJsonFile: "sabnzbd_history")
                    result = sut.parseHistory(from: response).value
                }

                afterEach {
                    result = nil
                }

                it("parses 1 item") {
                    expect(result.count) == 1
                }
            }
        }
    }
}

private extension Data {
    init(fromJsonFile filename: String) {
        let bundle = Bundle(for: SabNZBdResponseParserSpec.self)
        let filePath = bundle.path(forResource: filename, ofType: "json")!

        // swiftlint:disable force_try
        try! self.init(contentsOf: URL(fileURLWithPath: filePath))
    }
}
