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
    case download_deleteItem
    case dvr_addShow
    case dvr_deleteShow
}

protocol ErrorHandling {
    func handle(error: DownError, action: ErrorSourceAction, source: UIViewController)
}

struct ErrorHandler: ErrorHandling {
    func handle(error: DownError, action: ErrorSourceAction, source: UIViewController) {
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
        case .download_deleteItem: description = "deleting item"
        case .dvr_addShow: description = "adding show"
        case .dvr_deleteShow: description = "deleting show"
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
        default:
            return localizedDescription
        }
    }
}

private extension ParseError {
    var displayString: String {
        switch self {
        case .api(message: let message):
            return "API: \(message)"
        default:
            return localizedDescription
        }
    }
}
