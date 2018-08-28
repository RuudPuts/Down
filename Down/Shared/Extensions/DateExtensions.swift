//
//  DateExtensions.swift
//  Down
//
//  Created by Ruud Puts on 28/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

extension TimeInterval {
    var displayString: String {
        return Date(timeIntervalSinceReferenceDate: self).timeString
    }
}

extension Date {
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "HH:mm:ss"
        if self.timeIntervalSinceReferenceDate < 3600 {
            formatter.dateFormat = "mm:ss"
        }

        return formatter.string(from: self)
    }

    var dateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM HH:mm"

        return formatter.string(from: self)
    }
}
