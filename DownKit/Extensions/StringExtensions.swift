//
//  String.swift
//  DownKit
//
//  Created by Ruud Puts on 13/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

internal extension String {
    func strip() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func matches(_ regex: String) -> Bool {
        do {
            return try !NSRegularExpression(pattern: regex, options: [])
                .matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
                .isEmpty
        }
        catch {
            NSLog("Error while matching '\(regex)' to \(self):\n\t\(error.localizedDescription)")
            return false
        }
    }

    func components(matching regex: String) -> [String]? {
        do {
            return try NSRegularExpression(pattern: regex, options: [])
                .matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
                .map { String(self[Range($0.range, in: self)!]) }
        }
        catch {
            NSLog("Error while matching '\(regex)' to \(self):\n\t\(error.localizedDescription)")
            return nil
        }
    }

    func inject(parameters: [String: Any]?) -> String {
        var result = self
        
        // swiftlint:disable force_try
        try! NSRegularExpression(pattern: "\\{(\\w{1,})\\}")
            .matches(in: result, range: NSRange(location: 0, length: result.count))
            .reversed().forEach { match in
            let fullRange = Range(match.range, in: result)!
            let fullMatch = String(result[fullRange])
            
            let keyRange = Range(match.range(at: 1), in: result)!
            let key = String(result[keyRange])
            
            if let value = parameters?[key] {
                result = result.replacingOccurrences(of: fullMatch, with: "\(value)")
            }
            else {
                print("No value passed for '\(key)' parameter")
            }
        }
        
        return result
    }
}
