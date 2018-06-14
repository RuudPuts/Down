//
//  SickbeardResponseParserSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble
import SwiftyJSON

class SickbeardResponseParserSpec: QuickSpec {
    override func spec() {
        describe("SickbeardResponseParser") {
            var sut: SickbeardResponseParser!
            var storage: DataStoringMock!
            
            beforeEach {
                sut = SickbeardResponseParser()
                storage = DataStoringMock()
            }
            
            afterEach {
                storage = nil
                sut = nil
            }
            
            context("empty parsed storage") {
                var storage: SickbeardResponseParser.ParsedStorage<Any>!
                
                beforeEach {
                    storage = .empty
                }
                
                afterEach {
                    storage = nil
                }
                
                it("sets empty result") {
                    expect(storage.result) == ""
                }
                
                it("sets empty message") {
                    expect(storage.message) == ""
                }
            }
            
            context("parse datastoring") {
                var result: SickbeardResponseParser.ParsedStorage<JSON>!
                
                afterEach {
                    result = nil
                }
                
                context("without data") {
                    beforeEach {
                        result = sut.parse(storage)
                    }
                    
                    it("produces empty response") {
                        expect(result.data).to(beNil())
                    }
                }
                
                context("from succesful response") {
                    beforeEach {
                        storage.stubs.data = self.successJson
                        result = sut.parse(storage)
                    }
                    
                    it("sets the result") {
                        expect(result.result) == "success"
                    }
                    
                    it("sets the data") {
                        expect(result.data) == ["api_version": 4]
                    }
                }
                
                context("from failure response") {
                    beforeEach {
                        storage.stubs.data = self.errorJson
                        result = sut.parse(storage)
                    }
                    
                    it("sets the result") {
                        expect(result.result) == "error"
                    }
                    
                    it("sets the data") {
                        expect(result.data) == "No such cmd: ''"
                    }
                }
                
                context("from incomplete response") {
                    beforeEach {
                        storage.stubs.data = self.incompleteJson
                        result = sut.parse(storage)
                    }
                    
                    it("produces empty response") {
                        expect(result.data) == JSON.null
                    }
                }
                
                context("from invalid response") {
                    beforeEach {
                        storage.stubs.data = "invalid response".data(using: .utf8)
                        result = sut.parse(storage)
                    }
                    
                    it("produces empty response") {
                        expect(result.data).to(beNil())
                    }
                }
            }
            
            context("parse datastoring to shows") {
                var result: [DvrShow]!
                
                beforeEach {
                    storage.stubs.data = self.showsJson
                    result = sut.parseShows(from: storage)
                }
                
                afterEach {
                    result = nil
                }
                
                it("parses 1 show") {
                    expect(result.count) == 1
                }
                
                it("parses the show's id") {
                    expect(result.first?.identifier) == "78804"
                }
                
                it("parses the show's name") {
                    expect(result.first?.name) == "Doctor Who (2005)"
                }
                
                it("parses the show's quality") {
                    expect(result.first?.quality) == "HD720p"
                }
            }
            
            context("parse datastoring to show with details") {
                var result: DvrShow!
                
                beforeEach {
                    storage.stubs.data = self.showDetailsJson
                    result = sut.parseShowDetails(from: storage)
                }
                
                afterEach {
                    result = nil
                }
                
                it("parses the show's id") {
                    expect(result.identifier) == "" // 78804
                }
                
                it("parses the show's name") {
                    expect(result.name) == "Doctor Who (2005)"
                }
                
                it("parses the show's quality") {
                    expect(result.quality) == "HD720p"
                }
                
                it("parses 1 season") {
                    expect(result.seasons?.count) == 1
                }
                
                it("parses the season's id") {
                    expect(result.seasons?.first?.identifier) == "5"
                }
                
                it("parses 1 episode") {
                    expect(result.seasons?.first?.episodes.count) == 1
                }
                
                it("parses the episode's identifier") {
                    expect(result.seasons?.first?.episodes.first?.identifier) == "7"
                }
                
                it("parses the episode's name") {
                    expect(result.seasons?.first?.episodes.first?.name) == "Amy's Choice"
                }
                
                it("parses the episode's airdate") {
                    expect(result.seasons?.first?.episodes.first?.airdate) == "2010-05-15"
                }
                
                it("parses the episode's quality") {
                    expect(result.seasons?.first?.episodes.first?.quality) == "N/A"
                }
                
                it("parses the episode's status") {
                    expect(result.seasons?.first?.episodes.first?.status) == "Ignored"
                }
            }
        }
    }
    
    
    var successJson: Data {
        return try! JSON([
            "result": "success",
            "message": "",
            "data": [
                "api_version": 4
            ]
            ]).rawData()
    }
    
    var errorJson: Data {
        return try! JSON([
            "data": "No such cmd: ''",
            "message": "",
            "result": "error",
            ]).rawData()
    }
    
    var incompleteJson: Data {
        return try! JSON(["result": ""]).rawData()
    }
    
    var showsJson: Data {
        return try! JSON([
            "data": [
                "78804": [
                    "air_by_date": 0,
                    "cache": [
                        "banner": 1,
                        "poster": 1
                    ],
                    "language": "en",
                    "network": "BBC One",
                    "next_ep_airdate": "",
                    "paused": 0,
                    "quality": "HD720p",
                    "show_name": "Doctor Who (2005)",
                    "status": "Continuing",
                    "tvdbid": 78804,
                    "tvrage_id": 3332,
                    "tvrage_name": "Doctor Who (2005)"
                ]
            ],
            "message": "",
            "result": "success"
            ]).rawData()
    }
    
    var showDetailsJson: Data {
        return try! JSON([
            "data": [
                "show": [
                    "data": [
                        "air_by_date": 0,
                        "airs": "Saturday 6:45 PM",
                        "cache": [
                            "banner": 1,
                            "poster": 1
                        ],
                        "flatten_folders": 0,
                        "genre": [
                            "Adventure",
                            "Drama",
                            "Science-Fiction"
                        ],
                        "language": "en",
                        "location": "/Volumes/TV Shows/Doctor Who (2005)",
                        "network": "BBC One",
                        "next_ep_airdate": "",
                        "paused": 0,
                        "quality": "HD720p",
                        "quality_details": [
                            "archive": [],
                            "initial": [
                                "hdtv",
                                "hdwebdl",
                                "hdbluray"
                            ]
                        ],
                        "season_list": [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
                        "show_name": "Doctor Who (2005)",
                        "status": "Continuing",
                        "tvrage_id": 3332,
                        "tvrage_name": "Doctor Who (2005)"
                    ],
                    "message": "",
                    "result": "success"
                ],
                "show.seasons": [
                    "data": [
                        "5": [
                            "7": [
                                "airdate": "2010-05-15",
                                "name": "Amy's Choice",
                                "quality": "N/A",
                                "status": "Ignored"
                            ],
                        ]
                    ],
                    "message": "",
                    "result": "success"
                ]
            ],
            "message": "",
            "result": "success"
            ]).rawData()
    }
}
