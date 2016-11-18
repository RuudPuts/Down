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
    public var category: String!
    public var nzbName: String!
    var progressDescription: String?
    public var sickbeardEpisode: SickbeardEpisode?
    
    var imdbTitle: String?
    
    public var status: SabItemStatus {
        get {
            let s = SabItemStatus(rawValue: statusString) ?? .unknown
            if s == .unknown {
                NSLog("Unknown status string: \(statusString)")
            }
            return s
        }
        set {
            statusString = newValue.rawValue
        }
    }
    internal var statusString: String!
    
    public enum SabItemStatus: String {
        case unknown
        
        // Queue
        case grabbing = "Grabbing"
        case downloading = "Downloading"
        
        // History
        case verifying = "Verifying"
        case repairing = "Repairing"
        case extracting = "Extracting"
        case runningScript = "Running"
        case failed = "Failed"
        case completed = "Completed"
        
        // General
        case queued = "Queued"
    }
    
    init(_ identifier: String, _ category: String, _ nzbName: String, _ statusString: String) {
        self.identifier = identifier
        self.category = category
        self.nzbName = nzbName
        self.statusString = statusString;
    }    
    
    public var imdbIdentifier: String? {
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
    
    public var displayName: String! {
        var displayName = nzbName as String
        if let imdbTitle = self.imdbTitle {
            displayName = imdbTitle
        }
        else if let sickbeardEpisode = self.sickbeardEpisode {
            displayName = sickbeardEpisode.title
        }
        else {
            displayName = displayName.replacingOccurrences(of: ".", with: " ")
        }
        
        return displayName
    }
    
    public func statusDescription() -> String? {
        return status == .runningScript ? "Running script" : status.rawValue
    }
   
}

func == (lhs: SABItem, rhs: SABItem) -> Bool {
    return lhs.identifier == rhs.identifier
}
