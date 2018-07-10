//
//  SabNZBdResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class SabNZBdResponseParser: DownloadResponseParsing {    
    func parseQueue(from storage: DataStoring) throws -> DownloadQueue {
        let json = try parse(storage, forCall: .queue)
        
        let items = json["slots"].array?.map {
            DownloadItem(identifier: $0["nzo_id"].stringValue,
                         name: $0["filename"].stringValue)
        }
        
        return DownloadQueue(currentSpeed: json["speed"].stringValue.strip(),
                             timeRemaining: json["timeleft"].stringValue,
                             mbRemaining: json["mbleft"].stringValue,
                             items: items ?? [])
    }
    
    func parseHistory(from storage: DataStoring) throws -> [DownloadItem] {
        return try parse(storage, forCall: .history)["slots"].array?.map {
            DownloadItem(identifier: $0["id"].stringValue,
                         name: $0["nzb_name"].stringValue)
        } ?? []
    }
}

extension SabNZBdResponseParser: ApiApplicationResponseParsing {
    func parseLoggedIn(from storage: DataStoring) throws -> Bool {
        //! Might want to check http response code 😅
        return try parse(storage)
            .range(of: "<form class=\"form-signin\" action=\"./\" method=\"post\">") == nil
    }

    func parseApiKey(from storage: DataStoring) throws -> String? {
        //! Might want to check http response code 😅
        let result = try parse(storage)
        guard let keyRange = result.range(of: "id=\"apikey\"") else {
            return nil
        }

        return result[keyRange.upperBound...].components(matching: "[a-zA-Z0-9]{32}")?.first
    }
}

extension StringProtocol {
    func components(matching regex: String) -> [String]? {
        guard let value = self as? String else {
            return nil
        }

        do {
            return try NSRegularExpression(pattern: regex, options: [])
                .matches(in: value, options: [], range: NSRange(location: 0, length: value.count))
                .map { String(value[Range($0.range, in: value)!]) }
        }
        catch {
            NSLog("Error while matching '\(regex)' to \(self):\n\t\(error.localizedDescription)")
            return nil
        }
    }
}

extension SabNZBdResponseParser {
    func parse(_ storage: DataStoring, forCall call: DownloadApplicationCall) throws -> JSON {
        guard let data = storage.data else {
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

extension String {
    func strip() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
