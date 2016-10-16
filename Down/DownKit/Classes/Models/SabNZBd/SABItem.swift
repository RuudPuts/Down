//
//  SABItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

open class SABItem: NSObject {
    
    open let identifier: String!
    open var category: String!
    open var nzbName: String!
    var progressDescription: String?
    open var statusDescription: String!
    open var sickbeardEpisode: SickbeardEpisode?
    
    var imdbTitle: String?
    
    init(_ identifier: String, _ category: String, _ nzbName: String, _ statusDescription: String) {
        self.identifier = identifier
        self.category = category
        self.nzbName = nzbName
        self.statusDescription = statusDescription;
    }    
    
    open var imdbIdentifier: String? {
        var imdbIdentifier:String? = nil
        
        // Detect IMDB id
        let regex = "tt[0-9]{7}"
        var regularExpression: NSRegularExpression
        do {
            try regularExpression = NSRegularExpression(pattern: regex, options: .caseInsensitive)
            
            let range = regularExpression.rangeOfFirstMatch(in: nzbName, options: [], range: nzbName.fullNSRange) as NSRange!
            if range?.location != NSNotFound {
                imdbIdentifier = (nzbName as NSString).substring(with: range!)
            }
        }
        catch _ {
            
        }
        
        return imdbIdentifier
    }
    
    open var displayName: String! {
        var displayName = nzbName as String
        if let imdbTitle = self.imdbTitle {
            displayName = imdbTitle
        }
        else if let sickbeardEpisode = self.sickbeardEpisode , !sickbeardEpisode.isInvalidated {
            displayName = sickbeardEpisode.title
        }
        else {
            displayName = displayName.replacingOccurrences(of: ".", with: " ")
        }
        
        return displayName
    }
   
}

func == (lhs: SABItem, rhs: SABItem) -> Bool {
    return lhs.identifier == rhs.identifier
}
