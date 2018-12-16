//
//  SickbeardResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class SickbeardResponseParser: DvrResponseParsing {
    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }

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

    func validateServerHeader(in response: Response) -> Bool {
        return response.headers?["Server"]?.matches("CherryPy\\/.*?") ?? false
    }

    func parseLoggedIn(from response: Response) throws -> LoginResult {
        guard validateServerHeader(in: response) else {
            return .failed
        }

        if response.statusCode >= 400 && response.statusCode < 500 {
            return .authenticationRequired
        }

        if response.statusCode >= 200 && response.statusCode < 400 {
            return .success
        }

        return .failed
    }

    func parseApiKey(from response: Response) throws -> String? {
        let result: String = try parse(response)
        guard let keyRange = result.range(of: "id=\"api_key\"") else {
            return nil
        }

        return String(result[keyRange.upperBound...]).components(matching: "[a-zA-Z0-9]{32}")?.first
    }
}

private extension SickbeardResponseParser {
    func parseShow(from json: JSON, keymap: ParseShowsKeyMaping.Type) -> DvrShow {
        var identifier = json[keymap.id].stringValue
        if identifier.isEmpty {
            identifier = DvrShow.partialIdentifier
        }

        let show = DvrShow(
            identifier: identifier,
            name: json[keymap.name].stringValue
        )
        show.quality = parseQuality(from: json["quality"])
        show.network = json["network"].stringValue
        show.airTime = json["airs"].stringValue
        show.status = parseShowStatus(from: json["status"])

        return show
    }
    
    func parseEpisodes(from json: JSON) -> [DvrEpisode] {
        return json.dictionary?.map { identifier, data in
            let airDate = DateFormatter.dateFormatter()
                .date(from: data["airdate"].stringValue)

            let status = DvrEpisodeStatus.from(sickbeardValue: data["status"].stringValue)

            return DvrEpisode(
                identifier: identifier,
                name: data["name"].stringValue,
                airdate: airDate,
                quality: parseQuality(from: data["quality"]),
                status: status
            )
        } ?? []
    }

    func parseQuality(from json: JSON) -> Quality {
        switch json.stringValue {
        case "HD1080p": return .hd720p
        case "HD720p": return .hd720p
        case "HDTV": return .hdtv
        default: return .unknown
        }
    }

    func parseShowStatus(from json: JSON) -> DvrShowStatus {
        switch json.stringValue {
        case "Continuing": return .continuing
        case "Ended": return .ended
        default: return .unknown
        }
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
            throw ParseError.api(message: json["message"].stringValue)
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

extension DvrEpisodeStatus {
    static func from(sickbeardValue string: String) -> DvrEpisodeStatus {
        switch string.lowercased() {
        case DvrEpisodeStatus.wanted.sickbeardValue: return .wanted
        case DvrEpisodeStatus.skipped.sickbeardValue: return .skipped
        case DvrEpisodeStatus.archived.sickbeardValue: return .archived
        case DvrEpisodeStatus.ignored.sickbeardValue: return .ignored
        case DvrEpisodeStatus.snatched.sickbeardValue: return .snatched
        case DvrEpisodeStatus.downloaded.sickbeardValue: return .downloaded
        case DvrEpisodeStatus.unaired.sickbeardValue: return .unaired
        default: return .unknown
        }
    }

    var sickbeardValue: String {
        switch self {
        case .unknown: return "unknown"
        case .wanted: return "wanted"
        case .skipped: return "skipped"
        case .archived: return "archived"
        case .ignored: return "ignored"
        case .unaired: return "unaired"
        case .snatched: return "snatched"
        case .downloaded: return "downloaded"
        }
    }
}

private extension DateFormatter {
    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
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
