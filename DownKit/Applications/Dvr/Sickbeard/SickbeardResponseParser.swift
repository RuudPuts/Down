//
//  SickbeardResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class SickbeardResponseParser: DvrResponseParsing {
    
    func parseShows(from storage: DataStoring) throws -> [DvrShow] {
        return try parse(storage)
            .dictionary?.map {
                var json = $0.value
                json["id"].stringValue = $0.key
                
                return parseShow(from: json)
            }
            ?? []
    }
    
    func parseShowDetails(from storage: DataStoring) throws -> DvrShow {
        let data = try parse(storage)
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
    func parseLoggedIn(from storage: DataStoring) throws -> Bool {
        //! Might want to check http response code 😅
        return try parse(storage).count > 0
    }

    func parseApiKey(from storage: DataStoring) throws -> String? {
        //! Might want to check http response code 😅
        let result: String = try parse(storage)
        guard let keyRange = result.range(of: "id=\"api_key\"") else {
            return nil
        }

        return result[keyRange.upperBound...].components(matching: "[a-zA-Z0-9]{32}")?.first
    }
}

extension SickbeardResponseParser {
    func parse(_ storage: DataStoring) throws -> JSON {
        guard let data = storage.data else {
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
