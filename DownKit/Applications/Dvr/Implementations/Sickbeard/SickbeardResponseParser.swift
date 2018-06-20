//
//  SickbeardResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class SickbeardResponseParser: DvrResponseParsing {
    struct ParsedStorage<DataType> {
        let result: String
        let message: String
        let data: DataType?
        
        static var empty: ParsedStorage { // should throw exception on failure
            return ParsedStorage(result: "", message: "", data: nil)
        }
    }
    
    func parseShows(from storage: DataStoring) -> [DvrShow] {
        let parsedStorage = parse(storage)
        
        return parsedStorage.data?
            .dictionary?.map {
                var json = $0.value
                json["id"].stringValue = $0.key
                
                return makeShow(from: json)
            }
            ?? []
    }
    
    func parseShowDetails(from storage: DataStoring) -> DvrShow {
        let parsedStorage = parse(storage)
        
        guard let showData = parsedStorage.data?["show"]["data"],
              let seasonsData = parsedStorage.data?["show.seasons"]["data"] else {
            fatalError("ohooh") //! Maybe a throw? lol
        }
        
        let show = makeShow(from: showData)
        let seasons = seasonsData.dictionary?.map {
            return DvrSeason(
                identifier: $0.key,
                episodes: parseEpisodes(from: $0.value)
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
    func parse(_ storage: DataStoring) -> ParsedStorage<JSON> {
        guard let data = storage.data else {
            return ParsedStorage.empty
        }
        
        do {
            let json = try JSON(data: data)
            
            return ParsedStorage( // Throw exception on failure
                result: json["result"].string ?? "",
                message: json["message"].string ?? "",
                data: json["data"])
        }
        catch {
            print("Sickbeard parse error: \(error)")
            return ParsedStorage.empty
        }
    }
}
