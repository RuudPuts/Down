//
//  SABItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

public class SABItem: NSObject {
    
    public let identifier: String!
    let filename: String!
    public var category: String!
    public let nzbName: String!
    var progressDescription: String?
    public var statusDescription: String!
    weak public var sickbeardEpisode: SickbeardEpisode?
    
    var imdbTitle: String?
    
    init(_ identifier: String, _ filename: String, _ category: String, _ nzbName: String, _ statusDescription: String) {
        self.identifier = identifier
        self.filename = filename
        self.category = category
        self.nzbName = nzbName
        self.statusDescription = statusDescription;
    }    
    
    public var imdbIdentifier: String? {
        var imdbIdentifier:String? = nil
        
        // Detect IMDB id
        let regex = "tt[0-9]{7}"
        var regularExpression: NSRegularExpression
        do {
            try regularExpression = NSRegularExpression(pattern: regex, options: .CaseInsensitive)
            
            let range = regularExpression.rangeOfFirstMatchInString(filename, options: .Anchored, range: filename.fullNSRange) as NSRange!
            if (range.location != NSNotFound) {
                imdbIdentifier = (self.filename as NSString).substringWithRange(range!)
            }
        }
        catch _ {
            
        }
        
        return imdbIdentifier
    }
    
    public var displayName: String! {
        var displayName = self.filename as String
        if let imdbTitle = self.imdbTitle {
            displayName = imdbTitle
        }
//        else if let sickbeardEpisode = self.sickbeardEpisode {
//            displayName = sickbeardEpisode.displayName
//        }
        else {
            displayName = displayName.stringByReplacingOccurrencesOfString(".", withString: " ")
        }
        
        return displayName
    }
   
}

func == (lhs: SABItem, rhs: SABItem) -> Bool {
    return lhs.identifier == rhs.identifier
}