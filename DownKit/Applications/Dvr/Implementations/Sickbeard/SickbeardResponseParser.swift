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
                
                return makeShow(from: json)
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
        
        let show = makeShow(from: showData)
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
    func makeShow(from json: JSON) -> DvrShow {
        return DvrShow(
            identifier: json["id"].string ?? DvrShow.partialIdentifier,
            name: json["show_name"].string ?? "",
            quality: json["quality"].string ?? ""
        )
    }
    
    func parseEpisodes(from json: JSON) -> [DvrEpisode] {
        return json.dictionary?.map {
            DvrEpisode(
                identifier: $0,
                name: $1["name"].string ?? "",
                airdate: $1["airdate"].string ?? "",
                quality: $1["quality"].string ?? "",
                status: $1["status"].string ?? ""
            )
            } ?? []
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
            throw ParseError.api(message: json["data"].string ?? "")
        }
        
        return json["data"]
    }
}
