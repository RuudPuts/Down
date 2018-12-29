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
    static var tomorrow: Date {
        return Date().addingDays(1)
    }

    var isInThePast: Bool {
        return isBefore(Date())
    }

    func isBefore(_ otherDate: Date) -> Bool {
        return otherDate.timeIntervalSince(self) > 0
    }

    func addingDays(_ days: Int) -> Date {
        return addingTimeInterval(86400 * Double(days))
    }

    var dayMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"

        return formatter.string(from: self)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = .current

        return formatter.string(from: self)
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "HH:mm:ss"
        if timeIntervalSinceReferenceDate < 3600 {
            formatter.dateFormat = "mm:ss"
        }

        return formatter.string(from: self)
    }

    var dateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = .current

        return formatter.string(from: self)
    }
}
