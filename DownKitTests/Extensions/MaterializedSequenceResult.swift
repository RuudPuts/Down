//
//  MaterializedSequenceResult.swift
//  DownKitTests
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxBlocking

extension MaterializedSequenceResult {
    var elements: [T]? {
        switch self {
        case .completed(elements: let elements):
            return elements
        case .failed(elements: let elements, error: _):
            return elements
        }
    }
    
    var error: Error? {
        switch self {
        case .completed(elements: _):
            return nil
        case .failed(elements: _, error: let error):
            return error
        }
    }
}
