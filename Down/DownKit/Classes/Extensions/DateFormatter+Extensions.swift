//
//  DateFormatter+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 20/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    class func downDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
}
