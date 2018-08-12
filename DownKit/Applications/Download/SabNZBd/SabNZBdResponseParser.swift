//
//  SabNZBdResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class SabNZBdResponseParser: DownloadResponseParsing {    
    func parseQueue(from response: Response) throws -> DownloadQueue {
        let json = try parse(response, forCall: .queue)
        
        let items = json["slots"].array?.map {
            DownloadItem(identifier: $0["nzo_id"].stringValue,
                         name: $0["filename"].stringValue)
        }

        let speed = Double(json["speed"].stringValue.split(separator: " ").first ?? "")
        let timeRemaining = DateFormatter.timeFormatter()
                                .date(from: json["timeleft"].stringValue)?
                                .inSeconds
        
        return DownloadQueue(speedMb: speed ?? 0,
                             remainingTime: timeRemaining ?? 0,
                             remainingMb: json["mbleft"].doubleValue,
                             items: items ?? [])
    }
    
    func parseHistory(from response: Response) throws -> [DownloadItem] {
        return try parse(response, forCall: .history)["slots"].array?.map {
            DownloadItem(identifier: $0["id"].stringValue,
                         name: $0["nzb_name"].stringValue)
        } ?? []
    }
}

extension SabNZBdResponseParser: ApiApplicationResponseParsing {
    func parseLoggedIn(from response: Response) throws -> LoginResult {
        //! Might want to check http response code 😅
        return try parse(response)
            .range(of: "<form class=\"form-signin\" action=\"./\" method=\"post\">") == nil ? .success : .authenticationRequired
    }

    func parseApiKey(from response: Response) throws -> String? {
        //! Might want to check http response code 😅
        let result = try parse(response)
        guard let keyRange = result.range(of: "id=\"apikey\"") else {
            return nil
        }

        return String(result[keyRange.upperBound...]).components(matching: "[a-zA-Z0-9]{32}")?.first
    }
}

extension SabNZBdResponseParser {
    func parse(_ response: Response, forCall call: DownloadApplicationCall) throws -> JSON {
        guard let data = response.data else {
            throw ParseError.noData
        }
        
        var json: JSON
        do {
            json = try JSON(data: data)
        }
        catch {
            print("SabNZBd parse error: \(error)")
            throw ParseError.invalidJson
        }
        
        guard json["status"].bool ?? true else {
            throw ParseError.api(message: json["error"].string ?? "")
        }
        
        return json[call.rawValue]
    }
}

private extension DateFormatter {
    static func timeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"

        return formatter
    }
}

private extension Date {
    var inSeconds: TimeInterval {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: self)

        return TimeInterval(components.hour! * 3600 + components.minute! * 60 + components.second!)
    }
}
