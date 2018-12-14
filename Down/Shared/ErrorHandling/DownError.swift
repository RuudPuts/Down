//
//  DownError.swift
//  Down
//
//  Created by Ruud Puts on 14/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation
import DownKit
import RxResult

enum DownError: Error {
    case request(Error)
    case unhandled(Error)
}

extension DownError: RxResultError {
    static func failure(from error: Error) -> DownError {
        switch error.self {
        case is RequestClientError: return .request(error)
        default: return .unhandled(error)
        }
    }
}
