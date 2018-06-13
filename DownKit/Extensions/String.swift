//
//  String.swift
//  DownKit
//
//  Created by Ruud Puts on 13/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

internal extension String {
    func inject(parameters: [String: Any]) -> String {
        guard let regex = try? NSRegularExpression(pattern: "\\{(\\w{1,})\\}") else {
            return self
        }
        
        var string = self
        let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.count))
        
        matches.reversed().forEach { result in
            let fullRange = Range(result.range, in: string)!
            let fullMatch = String(string[fullRange])
            
            let keyRange = Range(result.range(at: 1), in: string)!
            let key = String(string[keyRange])
            
            if let value = parameters[key] {
                string = string.replacingOccurrences(of: fullMatch, with: "\(value)")
            }
            else {
                print("No value passed for '\(key)' parameter")
            }
        }
        
        return string
    }
}
