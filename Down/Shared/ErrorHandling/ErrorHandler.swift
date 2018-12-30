//
//  ErrorHandler.swift
//  Down
//
//  Created by Ruud Puts on 07/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

enum ErrorSourceAction {
    case settings_updateCache

    case download_pauseQueue
    case download_resumeQueue
    case download_purgeHistory
    case download_deleteItem
    
    case dvr_addShow
    case dvr_deleteShow
    case dvr_setEpisodeStatus
}

protocol ErrorHandling {
    func handle(error: DownError, action: ErrorSourceAction, source: UIViewController)
}

struct ErrorHandler: ErrorHandling {
    func handle(error: DownError, action: ErrorSourceAction, source: UIViewController) {
        NSLog("❌ Handling error \(error)")

        let title = makeTitle(forAction: action)

        let alert = UIAlertController(title: title, message: error.displayString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))

        source.present(alert, animated: true, completion: nil)
    }
}

private extension ErrorHandler {
    func makeTitle(forAction action: ErrorSourceAction) -> String {
        let description: String
        switch action {
        case .settings_updateCache: description = "updating cache"
        case .download_pauseQueue: description = "pausing queue"
        case .download_resumeQueue: description = "resuming queue"
        case .download_purgeHistory: description = "purging history"
        case .download_deleteItem: description = "deleting item"
        case .dvr_addShow: description = "adding show"
        case .dvr_deleteShow: description = "deleting show"
        case .dvr_setEpisodeStatus: description = "setting episode status"
        }

        return "Error while \(description)"
    }
}

private extension DownError {
    var displayString: String {
        switch self {
        case .request(let error),
             .unhandled(let error):
            return error.displayString
        }
    }
}

private extension Error {
    var displayString: String {
        if let requestError = self as? RequestClientError {
            return requestError.displayString
        }
        else if let parseError = self as? ParseError {
            return parseError.displayString
        }

        return localizedDescription
    }
}

private extension RequestClientError {
    var displayString: String {
        switch self {
        case .generic(message: let message):
            return message
        case .invalidRequest:
            return "The request is not valid"
        case .invalidResponse:
            return "Received unexpected response from application"
        case .noData:
            return "No data received from application"
        }
    }
}

private extension ParseError {
    var displayString: String {
        switch self {
        case .api(message: let message):
            return "API: \(message)"
        case .noData:
            return "No data received from application"
        case .invalidData:
            return "Received invalid data from application"
        case .missingData:
            return "Received incomplete data from application"
        }
    }
}
