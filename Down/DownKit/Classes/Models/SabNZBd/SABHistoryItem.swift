//
//  SABHistoryItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

public class SABHistoryItem: SABItem {
    
    let title: String!
    public let size: String!
    public var actionLine: String?
    public var completionDate: Date?
    
    init(_ identifier: String, _ title: String, _ category: String, _ nzbName: String, _ size: String, _ statusString: String, _ actionLine: String, _ completionDate: Date) {
        self.size = size
        self.title = title
        self.actionLine = actionLine
        self.completionDate = completionDate
        
        super.init(identifier, category, nzbName, statusString)
    }
    
    internal func update(_ category: String, _ statusString: String, _ actionLine: String, _ completionDate: Date) {
        self.category = category
        self.statusString = statusString
        self.actionLine = actionLine
        self.completionDate = completionDate
    }
    
    public var hasProgress: Bool {
        var hasProgress = false
        if (self.status == .verifying || self.status == .repairing || self.status == .extracting) && self.progress > 0 {
            hasProgress = true
        }
        
        return hasProgress
    }
    
    public var progress: Float {
        var progress: Float = 0
        
        if status == .verifying || status == .extracting {
            let progressString = actionLine!.components(separatedBy: " ").last as String!
            let progressComponents = progressString?.components(separatedBy: "/")
            
            let part = Float((progressComponents?.first!)!) ?? 0
            let total = Float((progressComponents?.last!)!) ?? 0
            
            progress = part / total * 100
        }
        else if status == .repairing {
            let regex = "(\\d+)%$"
            
            if let percentage = actionLine!.componentsMatchingRegex(regex).first {
                let percentageNumber = percentage.replacingOccurrences(of: "%", with: "")
                progress = Float(percentageNumber) ?? 0
            }
        }
        
        return progress
    }
    
    public override func statusDescription() -> String? {
        if status == .verifying || status == .extracting {
            return actionLine
        }
        
        return super.statusDescription()
    }
    
}
