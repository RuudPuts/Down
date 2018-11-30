//
//  SickbeardResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON
import Result

class SickbeardResponseParser: DvrResponseParsing {
    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }

    func parseShows(from response: Response) -> Result<[DvrShow], DownKitError> {
        return parse(response).map {
            $0.dictionary?.map {
                var json = $0.value
                json["id"].stringValue = $0.key
                
                return parseShow(from: json, keymap: ParseShowListKeyMapping.self)
            }
            ?? []
        }
    }
    
    func parseShowDetails(from response: Response) -> Result<DvrShow, DownKitError> {
        guard let data = parse(response).value else {
            return .failure(.responseParsing(.noData))
        }

        let showData = data["show"]["data"]
        let seasonsData = data["show.seasons"]["data"]
        
        guard showData != JSON.null && seasonsData != JSON.null else {
            return .failure(.responseParsing(.missingData))
        }
        
        let show = parseShow(from: showData, keymap: ParseShowListKeyMapping.self)
        let seasons = seasonsData.dictionary?.map {
            return DvrSeason(
                identifier: $0.key,
                episodes: parseEpisodes(from: $0.value),
                show: show
            )}
            .sorted(by: { Int($0.identifier)! < Int($1.identifier)! })
        show.setSeasons(seasons ?? [])
        
        return .success(show)
    }

    func parseSearchShows(from response: Response) -> Result<[DvrShow], DownKitError> {
        return parse(response).map {
            $0["results"].array?
                .map { data in
                    parseShow(from: data, keymap: ParseSearchShowsKeyMapping.self)
                }
            ?? []
        }
    }

    func parseAddShow(from response: Response) -> Result<Bool, DownKitError> {
        //! Does this work if an error is already returned?
        // If an error does occur, this should return false
        return parse(response).map { _ in true }
    }

    func parseDeleteShow(from response: Response) -> Result<Bool, DownKitError> {
        return parse(response).map { _ in true }
    }

    func parseSetEpisodeStatus(from response: Response) -> Result<Bool, DownKitError> {
        return parse(response).map { _ in true }
    }

    func parseSetSeasonStatus(from response: Response) -> Result<Bool, DownKitError> {
        return parse(response).map { _ in true }
    }

    func validateServerHeader(in response: Response) -> Bool {

        /*
         < HTTP/1.1 303 See Other
         < Content-Length: 108
         < Vary: Accept-Encoding
         < Server: CherryPy/3.2.0rc1
         < Location: http://192.168.2.100:8081/home/
         < Date: Fri, 30 Nov 2018 21:05:53 GMT
         < Content-Type: text/html;charset=utf-8
         */

        return response.headers?["Server"]?.matches("CherryPy\\/.*?") ?? false
    }

    func parseLoggedIn(from response: Response) -> Result<LoginResult, DownKitError> {
        guard validateServerHeader(in: response) else {
            return .success(.failed)
        }

        if response.statusCode >= 400 && response.statusCode < 500 {
            return .success(.authenticationRequired)
        }

        if response.statusCode >= 200 && response.statusCode < 400 {
            return .success(.success)
        }

        return .success(.failed)
    }

    func parseApiKey(from response: Response) -> Result<String?, DownKitError> {
        let result: Result<String, DownKitError> = parse(response)

        return result.map {
            guard let keyRange = $0.range(of: "id=\"api_key\"") else {
                return nil
            }

            let apiKeyPart = String($0[keyRange.upperBound...])
            return apiKeyPart.components(matching: "[a-zA-Z0-9]{32}")?.first
        }
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
        .sorted(by: { Int($0.identifier)! < Int($1.identifier)! })
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
    func parse(_ response: Response) -> Result<JSON, DownKitError> {
        guard let data = response.data else {
            return .failure(.responseParsing(.noData))
        }
        
        var json: JSON
        do {
            json = try JSON(data: data)
        }
        catch {
            print("Sickbeard parse error: \(error)")
            return .failure(.responseParsing(.invalidJson))
        }
        
        return validate(json).map { $0["data"] }
    }

    func validate(_ json: JSON) -> Result<JSON, DownKitError> {
        let data = json["data"]
        guard json["result"].string == "success" else {
            return .failure(.responseParsing(.api(message: data.stringValue)))
        }
        
        let errors = data.dictionary?
            .map({ (key, value) -> JSON in
                return data[key]
            })
            .filter { $0["result"] != JSON.null }
            .filter { $0["result"].string != "success" }
            .compactMap { $0["message"].stringValue }

        if let error = errors?.first {
            return .failure(.responseParsing(.api(message: error)))
        }

        return .success(json)
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
