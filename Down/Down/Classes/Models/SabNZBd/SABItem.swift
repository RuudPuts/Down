//
//  SABItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABItem: NSObject {
    
    let identifier: String!
    let filename: String!
    let category: String!
    var progressDescription: String?
    let statusDescription: String!
    var sickbeardEntry: SickbeardHistoryItem?
    
    var imdbTitle: String?
    
    init(identifier: String, filename: String, category: String, statusDescription: String) {
        self.identifier = identifier
        self.filename = filename
        self.category = category
        self.statusDescription = statusDescription;
    }    
    
    var imdbIdentifier: String? {
        var imdbIdentifier:String? = nil
        
        // Detect IMDB id
        let regex = "tt[0-9]{7}"
        let regularExpression = NSRegularExpression(pattern: regex, options: nil, error: nil)!
        
        let range = regularExpression.rangeOfFirstMatchInString(self.filename, options: nil, range: self.filename.fullNSRange) as NSRange!
        if (range.location != NSNotFound) {
            imdbIdentifier = (self.filename as NSString).substringWithRange(range!)
        }
        
        return imdbIdentifier
    }
    
    var displayName: String! {
        var displayName = self.filename as String
        if (self.imdbTitle != nil) {
            displayName = self.imdbTitle!
        }
        else {
            displayName = displayName.stringByReplacingOccurrencesOfString(".", withString: " ")
        }
        
        return displayName
    }
   
}
