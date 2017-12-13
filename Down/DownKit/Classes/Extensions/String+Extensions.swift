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
    
    init(fromMB megabytes: Double) {
        let divider: Double = 1024.0
        let kilobytes = megabytes * divider
        guard kilobytes > 0 else {
            self = "0 KB"
            return
        }
        
        let suffixes = ["KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        let activeSize = floor(log(kilobytes) / log(divider))
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.numberStyle = .decimal

        let number = NSNumber(value: kilobytes / pow(divider, activeSize))
        let numberString = numberFormatter.string(from: number) ?? "Unknown"
        let suffix = suffixes[Int(activeSize)]

        self = "\(numberString)\(suffix)"
    }
    
    func insert(_ string: String, atIndex index: Int) -> String {
        let firstPart = String(describing: self.utf8.prefix(index))
        let lastPart = String(describing: self.utf8.suffix(self.utf8.count - index))

        return firstPart + string + lastPart
    }
    
    func componentsMatchingRegex(_ regex: String) -> [String] {
        var matches = [String]()
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let text = self as NSString
            // swiftlint:disable legacy_constructor
            let results = regex.matches(in: self, options: [], range: NSMakeRange(0, text.length))
            matches = results.map { text.substring(with: $0.range)}
        }
        catch {
            Log.d("invalid regex: \(error.localizedDescription)")
        }
        
        return matches
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var simple: String {
        var simpleString = self
        [".", "'", ":", "(", ")", "&"].forEach {
            simpleString = simpleString.replacingOccurrences(of: $0, with: "")
        }
        
        return simpleString
    }

    subscript (range: CountableRange<Int>) -> Substring {
        get {
            guard range.lowerBound >= 0,
                let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound, limitedBy: self.endIndex),
                let endIndex = self.index(startIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: self.endIndex) else {
                return Substring()
            }

            return self[startIndex...endIndex]
        }
    }

    func timeToSeconds() -> TimeInterval {
        guard let date = DateFormatter.downDateFormatter().date(from: self) else {
            return 0
        }

        let components = NSCalendar.current.dateComponents([.hour, .minute, .second], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0

        return TimeInterval(hour * 3600 + minute * 60 + second)
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
