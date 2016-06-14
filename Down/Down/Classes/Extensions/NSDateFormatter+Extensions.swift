//
//  NSDateFormatter+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 19/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
    
    class func downDateTimeFormatter() -> NSDateFormatter {
        return NSDateFormatter(dateFormat: "dd-MM-yyyy HH:mm")
    }
    
    class func downDateFormatter() -> NSDateFormatter {
        return NSDateFormatter(dateFormat: "yyyy-MM-dd")
    }
    
}