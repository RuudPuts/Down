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
