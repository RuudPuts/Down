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
            
            describe("parse Response") {
                var result: JSON!

                afterEach {
                    result = nil
                }

                context("without data") {
                    var parseError: ParseError!

                    beforeEach {
                        do {
                            result = try sut.parse(response, forKey: .queue)
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
                        response.data = Data(fromFile: "sabnzbd_success")
                        result = try? sut.parse(response, forKey: .queue)
                    }

                    it("parses the json's data") {
                        expect(result) == ["version": "2.0.0"]
                    }
                }

                context("from failure response") {
                    var parseError: ParseError!

                    beforeEach {
                        do {
                            response.data = Data(fromFile: "sabnzbd_error")
                            result = try sut.parse(response, forKey: .queue)
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
                            result = try sut.parse(response, forKey: .queue)
                        }
                        catch {
                            parseError = error as? ParseError
                        }
                    }

                    afterEach {
                        parseError = nil
                    }

                    it("throws invalid data error") {
                        expect(parseError) == ParseError.invalidData
                    }
                }
            }

            describe("download application response parser") {
                describe("parse queue Response") {
                    var result: DownloadQueue!

                    beforeEach {
                        response.data = Data(fromFile: "sabnzbd_queue")
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
                        response.data = Data(fromFile: "sabnzbd_history")
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

            describe("api application response parser") {
                context("parse login response") {
                    var result: LoginResult!

                    afterEach {
                        result = nil
                    }

                    context("without valid server header") {
                        context("succesful login") {
                            beforeEach {
                                response.data = Data(fromFile: "sabnzbd_apikey", extension: "html")
                                result = try? sut.parseLoggedIn(from: response)
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

                                result = try? sut.parseLoggedIn(from: response)
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

                                result = try? sut.parseLoggedIn(from: response)
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
                        result = (try? sut.parseApiKey(from: response)) ?? nil
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
    // swiftlint:enable function_body_length
}
