//
//  NSDate+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 20/08/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

extension NSDate {
    
    var dateString: String {
        get {
            return NSDateFormatter.downDateFormatter().stringFromDate(self)
        }
    }
}