//
//  String+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var length: Int {
        return count(self.utf16)
    }
    
    var fullNSRange: NSRange {
        return NSRange(location: 0, length: self.length)
    }
    
    var fullRange: Range<String.Index> {
        return self.startIndex..<self.endIndex
    }
    
    func toFloat() -> Float? {
        return floatValue
    }
}