//
//  ErrorHandler.swift
//  Down
//
//  Created by Ruud Puts on 07/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

enum ErrorSourceType {
    case dvr_addShow
}

protocol ErrorHandling {
    func handle(error: Error, type: ErrorSourceType, source: UIViewController)
}

class ErrorHandler: ErrorHandling {
    func handle(error: Error, type: ErrorSourceType, source: UIViewController) {
        let title: String
        switch type {
        case .dvr_addShow: title = "Error while adding show"
        }

        let alert = UIAlertController(title: title, message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))

        source.present(alert, animated: true, completion: nil)
    }
}
