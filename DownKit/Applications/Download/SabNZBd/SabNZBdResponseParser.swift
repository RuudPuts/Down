//
//  SabNZBdResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON
import Result

class SabNZBdResponseParser: DownloadResponseParsing {
    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }
    
    func parseQueue(from response: Response) -> Result<DownloadQueue, DownKitError> {
//        let json = parse(response, forKey: .queue).value ?? JSON.null
//
//        let items = json["slots"].array?.map { parseQueueItem(from: $0) }
//        let speed = parseMb(from: json["speed"])
//        let remainingTime = DateFormatter.timeFormatter()
//                                .date(from: json["timeleft"].stringValue)?
//                                .inSeconds
//
//        let parsedQueue = DownloadQueue(speedMb: speed,
//                                        remainingTime: remainingTime ?? 0,
//                                        remainingMb: json["mbleft"].doubleValue,
//                                        items: items ?? [])
//
//        return .success(parsedQueue)

        return parse(response, forKey: .queue).map {
            let items = $0["slots"].array?.map { parseQueueItem(from: $0) }
            let speed = parseMb(from: $0["speed"])
            let remainingTime = DateFormatter.timeFormatter()
                                    .date(from: $0["timeleft"].stringValue)?
                                    .inSeconds

            return DownloadQueue(speedMb: speed,
                                 remainingTime: remainingTime ?? 0,
                                 remainingMb: $0["mbleft"].doubleValue,
                                 items: items ?? [])
        }
    }
    
    func parseHistory(from response: Response) -> Result<[DownloadItem], DownKitError> {
        return parse(response, forKey: .history).map {
            $0["slots"].array?
                .map {
                    parseHistoryItem(from: $0)
                }
            ?? []
        }
    }

    func parseDeleteItem(from response: Response) -> Result<Bool, DownKitError> {
        return .success(true)
    }
}

extension SabNZBdResponseParser: ApiApplicationResponseParsing {
    func parseLoggedIn(from response: Response) -> Result<LoginResult, DownKitError> {
        //! Might want to check http response code 😅
        let loginFormStart = "<form class=\"form-signin\" action=\"./\" method=\"post\">"

        return parse(response).map {
            $0.range(of: loginFormStart) == nil ? .success : .authenticationRequired
        }
    }

    func parseApiKey(from response: Response)  -> Result<String?, DownKitError> {
        //! Might want to check http response code 😅
        return parse(response).map {
            guard let keyRange = $0.range(of: "id=\"apikey\"") else {
                return nil
            }

            let apiKeyPart = String($0[keyRange.upperBound...])
            return apiKeyPart.components(matching: "[a-zA-Z0-9]{32}")?.first
        }
    }
}

extension SabNZBdResponseParser {
    func parse(_ response: Response, forKey key: SabNZBdResponseKey) -> Result<JSON, DownKitError> {
        guard let data = response.data else {
            return .failure(.responseParsing(.noData))
        }
        
        var json: JSON
        do {
            json = try JSON(data: data)
        }
        catch {
            print("SabNZBd parse error: \(error)")
            return .failure(.responseParsing(.invalidJson))
        }
        
        guard json["status"].bool ?? true else {
            return .failure(.responseParsing(.api(message: json["error"].string ?? "")))
        }
        
        return .success(json[key.rawValue])
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
        let state = DownloadHistoryItem.State.from(string: json["status"].stringValue)
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
    static func from(string: String) -> DownloadHistoryItem.State {
        switch string.lowercased() {
        case "queued": return .queued
        case "verifying": return .verifying
        case "repairing": return .repairing
        case "extracting": return .extracting
        case "running": return .postProcessing
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
