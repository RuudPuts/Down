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
    var name: String?
    let category: String!
    
    var imdbTitle: String?
    
    init(identifier: String, filename: String, category: String) {
        self.identifier = identifier
        self.filename = filename
        self.category = category
    }    
    
    func imdbIdentifier() -> String? {
        var imdbIdentifier:String? = nil
        
        // Detect IMDB id
        let regex: String = "tt[0-9][0-9][0-9][0-9][0-9][0-9][0-9]"
        let regularExpression: NSRegularExpression = NSRegularExpression(pattern: regex, options: nil, error: nil)!
        
        let range: NSRange! = regularExpression.rangeOfFirstMatchInString(self.filename, options: nil, range: self.filename.fullRange)
        if (range.location != NSNotFound) {
            imdbIdentifier = (self.filename as NSString).substringWithRange(range!)
        }
        
        return imdbIdentifier
    }
    
    func displayName() -> String! {
        var displayName: String = self.filename
        if (self.imdbTitle != nil) {
            displayName = self.imdbTitle!
        }
        else {
            displayName = displayName.stringByReplacingOccurrencesOfString(".", withString: " ")
        }
        
        return displayName
    }
   
}
