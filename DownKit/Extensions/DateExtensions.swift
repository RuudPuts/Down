//
//  DateExtensions.swift
//  DownKit
//
//  Created by Ruud Puts on 09/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

extension Date {
    var withoutTime: Date {
        let calendar = Calendar.current

        return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self))!
    }

    var startOfDay: Date {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components)!
    }

    var endOfDayTime: Date {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59

        return calendar.date(from: components)!
    }

    func isBetweeen(date lhs: Date, and rhs: Date) -> Bool {
        return lhs.compare(self) == self.compare(rhs)
    }
}
