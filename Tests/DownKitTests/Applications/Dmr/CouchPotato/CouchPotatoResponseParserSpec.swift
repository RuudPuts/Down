//
//  CouchPotatoResponseParserSpec.swift
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

class CouchPotatoResponseParserSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("CouchPotatoResponseParser") {
            var sut: CouchPotatoResponseParser!
            var response: Response!
            
            beforeEach {
                sut = CouchPotatoResponseParser(application: ApiApplicationMock())
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
                    var parseError: ParseError!

                    beforeEach {
                        do {
                            result = try sut.parse(response)
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
                        response.data = Data(fromFile: "couchpotato_success")
                        result = try? sut.parse(response)
                    }

                    it("parses the json's data") {
                        expect(result) == ["success": true]
                    }
                }

                context("from failure response") {
                    var parseError: ParseError!

                    beforeEach {
                        do {
                            response.data = Data(fromFile: "couchpotato_error")
                            result = try sut.parse(response)
                        }
                        catch {
                            parseError = error as? ParseError
                        }
                    }

                    afterEach {
                        parseError = nil
                    }

                    it("throws api error") {
                        expect(parseError) == ParseError.api(message: "")
                    }
                }

                context("from invalid response") {
                    var parseError: ParseError!

                    beforeEach {
                        do {
                            response.data = "invalid response".data(using: .utf8)
                            result = try sut.parse(response)
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

            context("dmv application response parser") {
                context("parse movie list response") {
                    var result: [DmrMovie]!

                    beforeEach {
                        response.data = Data(fromFile: "couchpotato_movielist")
                        result = try? sut.parseMovies(from: response)
                    }

                    afterEach {
                        result = nil
                    }

                    it("parses 1 movie") {
                        expect(result.count) == 1
                    }

                    it("parses the movie's id") {
                        expect(result.first?.identifier) == "3e14133df6df4036b18e62ef75e4014f"
                    }

                    it("parses the movie's imdb id") {
                        expect(result.first?.imdb_id) == "tt1179933"
                    }

                    it("parses the movie's name") {
                        expect(result.first?.name) == "10 Cloverfield Lane"
                    }
                }
            }

            context("api application response parser") {
                context("parse login response") {
                    var result: LoginResult!

                    afterEach {
                        result = nil
                    }

                    context("without valid server header") {
                        context("succesful login") {
                            beforeEach {
                                response = Response(data: Data(fromFile: "couchpotato_apikey"),
                                                    statusCode: 200,
                                                    headers: nil)
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
                            headers = ["Server": "TornadoServer/Test"]
                        }

                        afterEach {
                            headers = nil
                        }

                        context("succesful login") {
                            beforeEach {
                                response = Response(data: Data(fromFile: "couchpotato_apikey"),
                                                    statusCode: 200,
                                                    headers: headers)
                                result = try? sut.parseLoggedIn(from: response)
                            }

                            it("returns success") {
                                expect(result) == .success
                            }
                        }

                        context("failed login by statuscode") {
                            beforeEach {
                                response = Response(data: nil, statusCode: 400, headers: headers)
                                result = try? sut.parseLoggedIn(from: response)
                            }

                            it("returns authentication required") {
                                expect(result) == .authenticationRequired
                            }
                        }

                        context("failed login by body") {
                            beforeEach {
                                response = Response(data: Data(fromFile: "couchpotato_login", extension: "html"),
                                                    statusCode: 200,
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
                        response.data = Data(fromFile: "couchpotato_apikey")
                        result = (try? sut.parseApiKey(from: response)) ?? nil
                    }

                    afterEach {
                        result = nil
                    }

                    it("parses the key") {
                        expect(result) == "API+KEY"
                    }
                }
            }
        }
    }
    // swiftlint:enable function_body_length
}
