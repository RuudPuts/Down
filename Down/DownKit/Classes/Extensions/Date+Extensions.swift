//
//  Date+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 22/06/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

public extension Date {
    
    func withoutTime() -> Date {
        let calendar = Calendar.current
        
        return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self))!
    }
    
    static func tomorrow() -> Date {
        return Date().addingTimeInterval(86400)
    }
    
}
