//
//  CouchPotatoResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON
import Result

class CouchPotatoResponseParser: DmrResponseParsing {
    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }

    func parseMovies(from response: Response) -> Result<[DmrMovie], DownKitError> {
        return parse(response).map {
            $0["movies"].array?
                .map {
                    return parseMovie(from: $0)
                }
            ?? []
        }
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
    func parseLoggedIn(from response: Response) -> Result<LoginResult, DownKitError> {
        if response.statusCode >= 400 && response.statusCode < 500 {
            return .success(.authenticationRequired)
        }

        if let data = response.data,
           let body = String(data: data, encoding: .utf8),
           body.contains("input class=\"username\"") {
            return .success(.authenticationRequired)
        }

        if response.statusCode >= 200 && response.statusCode < 400 {
            return .success(.success)
        }

        return .success(.failed)
    }

    func parseApiKey(from response: Response)  -> Result<String?, DownKitError> {
        return parse(response).map {
            $0["api_key"].string
        }
    }
}

extension CouchPotatoResponseParser {
    func parse(_ response: Response)  -> Result<JSON, DownKitError> {
        guard let data = response.data else {
            return .failure(.responseParsing(.noData))
        }
        
        var json: JSON
        do {
            json = try JSON(data: data)
        }
        catch {
            print("CouchPotato parse error: \(error)")
            return .failure(.responseParsing(.invalidJson))
        }

        return validate(json)
    }

    func validate(_ json: JSON) -> Result<JSON, DownKitError> {
        guard json["success"].boolValue else {
            return .failure(.responseParsing(.api(message: "")))
        }

        return .success(json)
    }
}
