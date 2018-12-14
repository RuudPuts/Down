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
                        response.data = Data(fromFile: "sabnzbd_success")
                        result = sut.parse(response, forKey: .queue)
                    }

                    it("parses the json's data") {
                        expect(result.value) == ["version": "2.0.0"]
                    }
                }

                context("from failure response") {
                    beforeEach {
                        response.data = Data(fromFile: "sabnzbd_error")
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

            context("download application response parser") {
                describe("parse queue Response") {
                    var result: DownloadQueue!

                    beforeEach {
                        response.data = Data(fromFile: "sabnzbd_queue")
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
                        response.data = Data(fromFile: "sabnzbd_history")
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

            context("parse login response") {
                var result: LoginResult!

                afterEach {
                    result = nil
                }

                context("without valid server header") {
                    context("succesful login") {
                        beforeEach {
                            response.data = Data(fromFile: "sabnzbd_apikey", extension: "html")
                            result = sut.parseLoggedIn(from: response).value
                        }

                        it("returns failed") {
                            expect(result) == .failed
                        }
                    }
                }

                context("with valid server header") {
                    var headers: [String: String]?

                    beforeEach {
                        headers = ["Server": "CherryPy/Test"]
                    }

                    afterEach {
                        headers = nil
                    }

                    context("succesful login") {
                        beforeEach {
                            response = Response(data: Data(fromFile: "sabnzbd_apikey", extension: "html"),
                                                statusCode: 200,
                                                headers: headers)

                            result = sut.parseLoggedIn(from: response).value
                        }

                        it("returns success") {
                            expect(result) == .success
                        }
                    }

                    context("failed login") {
                        beforeEach {
                            response = Response(data: Data(fromFile: "sabnzbd_login", extension: "html"),
                                                statusCode: 400,
                                                headers: headers)

                            result = sut.parseLoggedIn(from: response).value
                        }

                        it("returns authentication required") {
                            expect(result) == .authenticationRequired
                        }
                    }
                }
            }

            context("parse api key response") {
                var result: String?

                beforeEach {
                    response.data = Data(fromFile: "sabnzbd_apikey", extension: "html")
                    result = sut.parseApiKey(from: response).value ?? nil
                }

                afterEach {
                    result = nil
                }

                it("parses the key") {
                    expect(result) == "10480f3fd315c42728be2893595ede4a"
                }
            }
        }
    }
}

