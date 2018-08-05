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
                
                return parseShow(from: json, keymap: ParseShowListKeyMapping.self)
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
        
        let show = parseShow(from: showData, keymap: ParseShowListKeyMapping.self)
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
            .array?.map { data in
                parseShow(from: data, keymap: ParseSearchShowsKeyMapping.self)
            } ?? []
    }

    func parseAddShow(from response: Response) throws -> Bool {
        _ = try parse(response)

        return true
    }

    func parseDeleteShow(from response: Response) throws -> Bool {
        _ = try parse(response)

        return true
    }

    func parseSetEpisodeStatus(from response: Response) throws -> Bool {
        _ = try parse(response)

        return true
    }

    func parseSetSeasonStatus(from response: Response) throws -> Bool {
        _ = try parse(response)

        return true
    }
}

private extension SickbeardResponseParser {
    func parseShow(from json: JSON, keymap: ParseShowsKeyMaping.Type) -> DvrShow {
        var identifier = json[keymap.id].stringValue
        if identifier.count == 0 {
            identifier = DvrShow.partialIdentifier
        }

        let show = DvrShow(
            identifier: identifier,
            name: json[keymap.name].stringValue
        )
        show.quality = json["quality"].stringValue

        return show
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

        try validate(json)
        
        return json["data"]
    }

    func validate(_ json: JSON) throws {
        let data = json["data"]
        guard json["result"].string == "success" else {
            throw ParseError.api(message: data.stringValue)
        }

        // Check for any chained command and their results
        try data.dictionary?
            .map({ (key, value) -> JSON in
                guard value["data"] != JSON.null else {
                    return JSON.null
                }

                return data[key]
            })
            .filter { $0 != JSON.null }
            .forEach {
                guard $0["result"].string == "success" else {
                    throw ParseError.api(message: $0["message"].stringValue)
                }
            }
    }
}

protocol ParseShowsKeyMaping {
    static var id: String { get }
    static var name: String { get }
}

struct ParseShowListKeyMapping: ParseShowsKeyMaping {
    static var id = "id"
    static var name = "show_name"
}

struct ParseSearchShowsKeyMapping: ParseShowsKeyMaping {
    static var id = "tvdbid"
    static var name = "name"
}
