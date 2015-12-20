//
//  NSDateFormatter+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 20/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public extension NSDateFormatter {
    
    class func downDateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
}