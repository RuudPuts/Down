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
                sut = SabNZBdResponseParser()
                response = Response()
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
                    var parseError: ParseError!
                    
                    beforeEach {
                        do {
                            result = try sut.parse(response, forCall: .queue)
                        }
                        catch {
                            parseError = error as? ParseError
                        }
                    }
                    
                    afterEach {
                        parseError = nil
                    }
                    
                    it("throws no data error") {
                        expect(parseError) == ParseError.noData
                    }
                }
                
                context("from succesful response") {
                    beforeEach {
                        response.data = self.successJson
                        result = try? sut.parse(response, forCall: .queue)
                    }
                    
                    it("parses the json's data") {
                        expect(result) == ["version": "2.0.0"]
                    }
                }
                
                context("from failure response") {
                    var parseError: ParseError!
                    
                    beforeEach {
                        do {
                            response.data = self.errorJson
                            result = try sut.parse(response, forCall: .queue)
                        }
                        catch {
                            parseError = error as? ParseError
                        }
                    }
                    
                    afterEach {
                        parseError = nil
                    }
                    
                    it("throws api error") {
                        expect(parseError) == ParseError.api(message: "not implemented")
                    }
                }
                
                context("from invalid response") {
                    var parseError: ParseError!
                    
                    beforeEach {
                        do {
                            response.data = "invalid response".data(using: .utf8)
                            result = try sut.parse(response, forCall: .queue)
                        }
                        catch {
                            parseError = error as? ParseError
                        }
                    }
                    
                    afterEach {
                        parseError = nil
                    }
                    
                    it("throws invalid json error") {
                        expect(parseError) == ParseError.invalidJson
                    }
                }
            }
            
            context("parse queue Response") {
                var result: DownloadQueue!
                
                beforeEach {
                    response.data = self.queueJson
                    result = try? sut.parseQueue(from: response)
                }
                
                afterEach {
                    result = nil
                }
                
                it("parses current speed") {
                    expect(result.currentSpeed) == "0"
                }
                
                it("parses time remaining") {
                    expect(result.timeRemaining) == "0:00:00"
                }
                
                it("parses current data remaining") {
                    expect(result.mbRemaining) == "0.00"
                }
                
                it("parses 1 item") {
                    expect(result.items.count) == 1
                }
            }
            
            context("parse history Response") {
                var result: [DownloadItem]!
                
                beforeEach {
                    response.data = self.historyJson
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
    
    var successJson: Data {
        // swiftlint:disable force_try
        return try! JSON([
            "queue": [
                "version": "2.0.0"
            ]
        ]).rawData()
    }
    
    var errorJson: Data {
        // swiftlint:disable force_try
        return try! JSON([
            "status": false,
            "error": "not implemented"
        ]).rawData()
    }
    
    var queueJson: Data {
        // swiftlint:disable force_try
        return try! JSON([
            "queue": [
                "paused": false,
                "speed": "0  ",
                "status": "Idle",
                "mbleft": "0.00",
                "timeleft": "0:00:00",
                "mb": "0.00",
                "slots": [
                    [
                        "filename": "Marvels.Luke.Cage.S02E13.They.Reminisce.Over.You.720p.NF.WEB-DL.DDP5.1.x264-NTb"
                    ]
                ]
            ]
        ]).rawData()
    }
    
    var historyJson: Data {
        // swiftlint:disable force_try
        return try! JSON([
            "history": [
                "slots": [
                    [
                        "id": 4673,
                        "nzb_name": "Marvels.Luke.Cage.S02E13.They.Reminisce.Over.You.720p.NF.WEB-DL.DDP5.1.x264-NTb.nzb"
                    ]
                ]
            ]
        ]).rawData()
    }
}
