//
//  Listener.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

protocol Listener {
    func isEqualTo(other: Listener) -> Bool
}

extension Listener where Self : Equatable {
    func isEqualTo(other: Listener) -> Bool {
        guard let o = other as? Self else { return false }
        return self == o
    }
}