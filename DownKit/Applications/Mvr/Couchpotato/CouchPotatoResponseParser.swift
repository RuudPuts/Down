//
//  CouchPotatoResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class CouchPotatoResponseParser: DmrResponseParsing {
    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }

    func parseMovies(from response: Response) throws -> [DmrMovie] {
        return try parse(response)["movies"]
            .array?.map {
                return parseMovie(from: $0)
            }
            ?? []
    }
}

private extension CouchPotatoResponseParser {
    func parseMovie(from json: JSON) -> DmrMovie {
        return DmrMovie(identifier: json["_id"].stringValue,
                        imdb_id: json["identifiers"]["imdb"].stringValue,
                        name: json["title"].stringValue)
    }
}

extension CouchPotatoResponseParser: ApiApplicationResponseParsing {
    func validateServerHeader(in response: Response) -> Bool {
        return response.headers?["Server"]?.matches("TornadoServer\\/.*?") ?? false
    }

    func parseLoggedIn(from response: Response) throws -> LoginResult {
        guard validateServerHeader(in: response) else {
            return .failed
        }

        if response.statusCode >= 400 && response.statusCode < 500 {
            return .authenticationRequired
        }

        if let data = response.data,
           let body = String(data: data, encoding: .utf8),
           body.contains("input class=\"username\"") {
            return .authenticationRequired
        }

        if response.statusCode >= 200 && response.statusCode < 400 {
            return .success
        }

        return .failed
    }

    func parseApiKey(from response: Response) throws -> String? {
        let data = try parse(response)

        return data["api_key"].string
    }
}

extension CouchPotatoResponseParser {
    func parse(_ response: Response) throws -> JSON {
        guard let data = response.data else {
            throw ParseError.noData
        }
        
        var json: JSON
        do {
            json = try JSON(data: data)
        }
        catch {
            print("CouchPotato parse error: \(error)")
            throw ParseError.invalidData
        }

        try validate(json)
        
        return json
    }

    func validate(_ json: JSON) throws {
        guard json["success"].boolValue else {
            throw ParseError.api(message: "")
        }
    }
}
