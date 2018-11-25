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
                var result: JSON!
                
                afterEach {
                    result = nil
                }
                
                context("without data") {
                    var parseError: ResponseParsingError!
                    
                    beforeEach {
                        do {
                            result = try sut.parse(response, forKey: .queue)
                        }
                        catch {
                            parseError = error as? ResponseParsingError
                        }
                    }
                    
                    afterEach {
                        parseError = nil
                    }
                    
                    it("throws no data error") {
                        expect(parseError) == ResponseParsingError.noData
                    }
                }
                
                context("from succesful response") {
                    beforeEach {
                        response.data = Data(fromJsonFile: "sabnzbd_success")
                        result = try? sut.parse(response, forKey: .queue)
                    }

                    it("parses the json's data") {
                        expect(result) == ["version": "2.0.0"]
                    }
                }

                context("from failure response") {
                    var parseError: ResponseParsingError!

                    beforeEach {
                        do {
                            response.data = Data(fromJsonFile: "sabnzbd_error")
                            result = try sut.parse(response, forKey: .queue)
                        }
                        catch {
                            parseError = error as? ResponseParsingError
                        }
                    }

                    afterEach {
                        parseError = nil
                    }

                    it("throws api error") {
                        expect(parseError) == ResponseParsingError.api(message: "not implemented")
                    }
                }

                context("from invalid response") {
                    var parseError: ResponseParsingError!

                    beforeEach {
                        do {
                            response.data = "invalid response".data(using: .utf8)
                            result = try sut.parse(response, forKey: .queue)
                        }
                        catch {
                            parseError = error as? ResponseParsingError
                        }
                    }

                    afterEach {
                        parseError = nil
                    }

                    it("throws invalid json error") {
                        expect(parseError) == ResponseParsingError.invalidJson
                    }
                }
            }

            describe("parse queue Response") {
                var result: DownloadQueue!

                beforeEach {
                    response.data = Data(fromJsonFile: "sabnzbd_queue")
                    result = try? sut.parseQueue(from: response)
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
                    result = try? sut.parseHistory(from: response)
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
