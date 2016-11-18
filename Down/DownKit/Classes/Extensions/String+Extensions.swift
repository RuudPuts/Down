//
//  String+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

public extension String {
    
    var length: Int {
        return self.utf16.count
    }
    
    init(fromMB size: Float) {
        // TODO: See if a number formatter can be used here
        var sizeDisplay = "MB"
        var adjustedSize = size
        if adjustedSize < 0 {
            adjustedSize = adjustedSize * 1024
            sizeDisplay = "KB"
        }
        else if adjustedSize > 1024 {
            adjustedSize = adjustedSize / 1024
            sizeDisplay = "GB"
        }
        
        if adjustedSize > 0 {
            self = String(format: "%.1f%@", adjustedSize, sizeDisplay)
        }
        else {
            self = String(format: "%.0f%@", adjustedSize, sizeDisplay)
        }
    }
    
    func insert(_ string: String, atIndex index: Int) -> String {
        return  String(self.characters.prefix(index)) + string + String(self.characters.suffix(self.characters.count - index))
    }
    
    func componentsMatchingRegex(_ regex: String) -> [String] {
        var matches = [String]()
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let text = self as NSString
            let results = regex.matches(in: self, options: [], range: NSMakeRange(0, text.length))
            matches = results.map { text.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
        }
        
        return matches
    }
    
    var simple: String {
        var simpleString = self
        [".", "'", ":", "(", ")", "&"].forEach {
            simpleString = simpleString.replacingOccurrences(of: $0, with: "")
        }
        
        return simpleString
    }
    
    func substring(_ r: Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        
        return self[startIndex ..< endIndex]
    }
    
    func substring(from: Int) -> String {
        guard from < length else {
            return ""
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: from)
        return self[startIndex ..< self.endIndex]
    }
}

extension String {
    var fullNSRange: NSRange {
        return NSRange(location: 0, length: self.length)
    }
    
    var fullRange: Range<String.Index> {
        return self.startIndex..<self.endIndex
    }
}
