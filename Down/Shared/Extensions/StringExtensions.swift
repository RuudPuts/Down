//
//  StringExtensions.swift
//  Down
//
//  Created by Ruud Puts on 23/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

extension String {
    static func displayString(forMb mb: Double) -> String {
        var amount = Swift.max(mb, 0)
        var label = "MB"

        if amount > 1024 {
            amount /= 1024
            label = "GB"
        }
        else if amount < 1 {
            amount *= 1024
            label = "KB"
        }

        return String(format: "%.1f", amount) + " " + label
    }

    static func displayString(forSpeed mbSpeed: Double) -> String {
        return "\(displayString(forMb: mbSpeed))/s"
    }
}
