//
//  ServiceListener.swift
//  Down
//
//  Created by Ruud Puts on 12/08/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public protocol ServiceListener {
    func isEqualTo(_ other: ServiceListener) -> Bool
}

public extension ServiceListener where Self : Equatable {
    func isEqualTo(_ other: ServiceListener) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}
