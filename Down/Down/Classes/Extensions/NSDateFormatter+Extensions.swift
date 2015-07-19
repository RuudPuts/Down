//
//  NSDateFormatter+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 19/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    
    class func defaultFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter
    }
    
}