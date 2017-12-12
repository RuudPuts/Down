//
//  NSDateFormatter+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 19/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
    
    class func downDateTimeFormatter() -> DateFormatter {
        return DateFormatter(dateFormat: "dd-MM-yyyy HH:mm")
    }
    
    class func downDateFormatter() -> DateFormatter {
        return DateFormatter(dateFormat: "yyyy-MM-dd")
    }

    class func downTimeFormatter() -> DateFormatter {
        return DateFormatter(dateFormat: "HH:mm:ss")
    }
    
}
