//
//  SabNZBdResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class SabNZBdResponseParser: DownloadResponseParsing {
    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }
    
    func parseQueue(from response: Response) throws -> DownloadQueue {
        let json = try parse(response, forKey: .queue)
        
        let items = json["slots"].array?.map { parseQueueItem(from: $0) }
        let speed = parseMb(from: json["speed"])
        let remainingTime = DateFormatter.timeFormatter()
                                .date(from: json["timeleft"].stringValue)?
                                .inSeconds
        
        return DownloadQueue(speedMb: speed,
                             remainingTime: remainingTime ?? 0,
                             remainingMb: json["mbleft"].doubleValue,
                             isPaused: json["paused"].boolValue,
                             items: items ?? [])
    }
    
    func parseHistory(from response: Response) throws -> [DownloadItem] {
        return try parse(response, forKey: .history)["slots"].array?.map {
            parseHistoryItem(from: $0)
        } ?? []
    }

    func parseSuccess(from response: Response) throws -> Bool {
        return try parse(response)["status"].boolValue
    }
}

extension SabNZBdResponseParser: ApiApplicationResponseParsing {
    func validateServerHeader(in response: Response) -> Bool {
        return response.headers?["Server"]?.matches("CherryPy\\/.*?") ?? false
    }

    func parseLoggedIn(from response: Response) throws -> LoginResult {
        guard validateServerHeader(in: response) else {
            return .failed
        }

        let loginFormStart = "<form class=\"form-signin\" action=\"./\" method=\"post\">"

        return try parse(response).range(of: loginFormStart) == nil ? .success : .authenticationRequired
    }

    func parseApiKey(from response: Response) throws -> String? {
        let result = try parse(response)
        guard let keyRange = result.range(of: "id=\"apikey\"") else {
            return nil
        }

        return String(result[keyRange.upperBound...]).components(matching: "[a-zA-Z0-9]{32}")?.first
    }
}

extension SabNZBdResponseParser {
    func parse(_ response: Response, forKey key: SabNZBdResponseKey? = nil) throws -> JSON {
        guard let data = response.data else {
            throw ParseError.noData
        }
        
        var json: JSON
        do {
            json = try JSON(data: data)
        }
        catch {
            print("SabNZBd parse error: \(error)")
            throw ParseError.invalidData
        }
        
        guard json["status"].bool ?? true else {
            throw ParseError.api(message: json["error"].string ?? "")
        }

        if let key = key?.rawValue {
            return json[key]
        }

        return json
    }

    func parseQueueItem(from json: JSON) -> DownloadQueueItem {
        let state = DownloadQueueItem.State.from(string: json["status"].stringValue)
        let remainingTime = DateFormatter.timeFormatter()
            .date(from: json["timeleft"].stringValue)?
            .inSeconds

        return DownloadQueueItem(identifier: json["nzo_id"].stringValue,
                                 name: json["filename"].stringValue,
                                 category: json["cat"].stringValue,
                                 sizeMb: json["mb"].doubleValue,
                                 remainingMb: json["mbleft"].doubleValue,
                                 remainingTime: remainingTime ?? 0,
                                 progress: json["percentage"].doubleValue,
                                 state: state)
    }

    func parseMb(from value: JSON) -> Double {
        let components = value.stringValue.split(separator: " ")
        guard components.count == 2, var value = Double(components.first ?? "x") else {
            return 0
        }

        if components.last?.uppercased() == "K" {
            value /= 1024
        }

        return value
    }

    func parseHistoryItem(from json: JSON) -> DownloadHistoryItem {
        let state = DownloadHistoryItem.State.from(string: json["status"].stringValue,
                                                   withScript: json["script"].stringValue)
        let sizeMb = parseMb(from: json["size"])
        let progress = parseHistoryProgress(for: state, actionLine: json["action_line"].stringValue)
        let finishDate = Date(timeIntervalSince1970: json["completed"].doubleValue)

        return DownloadHistoryItem(identifier: json["nzo_id"].stringValue,
                                   name: json["nzb_name"].stringValue,
                                   category: json["category"].stringValue,
                                   sizeMb: sizeMb,
                                   progress: progress,
                                   finishDate: finishDate,
                                   state: state)
    }

    func parseHistoryProgress(for state: DownloadHistoryItem.State, actionLine: String) -> Double {
        switch state {
        case .verifying, .extracting:
            let components = actionLine
                .components(separatedBy: " ")
                .last?
                .components(separatedBy: "/")

            if let partString = components?.first, let totalString = components?.last {
                let part = Double(partString) ?? 0
                let total = Double(totalString) ?? 0

                return part / total * 100
            }

            return 0
        case .repairing:
            guard let percentageString = actionLine.components(matching: "(\\d+)%")?.first else {
                return 0
            }

            return Double(percentageString) ?? 0
        default:
            return 0
        }
    }
}

enum SabNZBdResponseKey: String {
    case queue
    case history
    case delete
}

extension DownloadQueueItem.State {
    static func from(string: String) -> DownloadQueueItem.State {
        switch string.lowercased() {
        case "queued": return .queued
        case "grabbing": return .grabbing
        case "downloading": return .downloading
        default: return .unknown
        }
    }
}

extension DownloadHistoryItem.State {
    static func from(string: String, withScript script: String) -> DownloadHistoryItem.State {
        switch string.lowercased() {
        case "queued": return .queued
        case "verifying": return .verifying
        case "repairing": return .repairing
        case "extracting": return .extracting
        case "running": return .postProcessing(script: script)
        case "failed": return .failed
        case "completed": return .completed
        default: return .unknown
        }
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
