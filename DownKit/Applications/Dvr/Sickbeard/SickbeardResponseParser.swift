//
//  SickbeardResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class SickbeardResponseParser: DvrResponseParsing {
    func parseShows(from response: Response) throws -> [DvrShow] {
        return try parse(response)
            .dictionary?.map {
                var json = $0.value
                json["id"].stringValue = $0.key
                
                return parseShow(from: json)
            }
            ?? []
    }
    
    func parseShowDetails(from response: Response) throws -> DvrShow {
        let data = try parse(response)
        let showData = data["show"]["data"]
        let seasonsData = data["show.seasons"]["data"]
        
        guard showData != JSON.null && seasonsData != JSON.null else {
            throw ParseError.missingData
        }
        
        let show = parseShow(from: showData)
        let seasons = seasonsData.dictionary?.map {
            return DvrSeason(
                identifier: $0.key,
                episodes: parseEpisodes(from: $0.value),
                show: show
            )}
        show.setSeasons(seasons ?? [])
        
        return show
    }

    func parseSearchShows(from response: Response) throws -> [DvrShow] {
        return try parse(response)["results"]
            .array?.map { parseShow(from: $0) } ?? []
    }

    func parseAddShow(from response: Response) throws -> Bool {
        _ = try parse(response)

        return true
    }
}

private extension SickbeardResponseParser {
    func parseShow(from json: JSON) -> DvrShow {
        return DvrShow(
            identifier: json["id"].string ?? DvrShow.partialIdentifier,
            name: json["show_name"].stringValue,
            quality: json["quality"].stringValue
        )
    }
    
    func parseEpisodes(from json: JSON) -> [DvrEpisode] {
        return json.dictionary?.map {
            DvrEpisode(
                identifier: $0,
                name: $1["name"].stringValue,
                airdate: $1["airdate"].stringValue,
                quality: $1["quality"].stringValue,
                status: $1["status"].stringValue
            )
        } ?? []
    }
}

extension SickbeardResponseParser: ApiApplicationResponseParsing {
    func parseLoggedIn(from response: Response) throws -> LoginResult {
        if response.statusCode >= 400 && response.statusCode < 500 {
            return .authenticationRequired
        }

        if response.statusCode >= 200 && response.statusCode < 400 {
            return .success
        }

        return .failed
    }

    func parseApiKey(from response: Response) throws -> String? {
        guard response.statusCode == StatusCodes.success.rawValue else {
            return nil
        }

        let result: String = try parse(response)
        guard let keyRange = result.range(of: "id=\"api_key\"") else {
            return nil
        }

        return String(result[keyRange.upperBound...]).components(matching: "[a-zA-Z0-9]{32}")?.first
    }
}

extension SickbeardResponseParser {
    func parse(_ response: Response) throws -> JSON {
        guard let data = response.data else {
            throw ParseError.noData
        }
        
        var json: JSON
        do {
            json = try JSON(data: data)
        }
        catch {
            print("Sickbeard parse error: \(error)")
            throw ParseError.invalidJson
        }
        
        guard json["result"].string == "success" else {
            throw ParseError.api(message: json["data"].stringValue)
        }
        
        return json["data"]
    }
}
