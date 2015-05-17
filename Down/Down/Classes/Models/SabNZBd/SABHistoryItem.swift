//
//  SABHistoryItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABHistoryItem: SABItem {
    
    let title: String!
    let size: String!
    var actionLine: String?
    var status: SABHistoryItemStatus?
    var completionDate: NSDate?
    
    internal enum SABHistoryItemStatus {
        case Queued
        case Verifying
        case Repairing
        case Extracting
        case RunningScript
        case Failed
        case Finished
    }
    
    init(_ identifier: String, _ title: String, _ filename: String, _ category: String, _ size: String, _ statusDescription: String, _ actionLine: String, _ completionDate: NSDate) {
        self.size = size
        self.title = title
        self.actionLine = actionLine
        self.completionDate = completionDate
        
        super.init(identifier, filename, category, statusDescription)
        
        self.status = stringToStatus(statusDescription)
    }
    
    internal func update(category: String, _ statusDescription: String, _ actionLine: String, _ completionDate: NSDate) {
        self.category = category
        self.statusDescription = statusDescription
        self.actionLine = actionLine
        self.completionDate = completionDate
        self.status = stringToStatus(statusDescription)
    }
    
    var hasProgress: Bool! {
        var hasProgress = false
        if ((self.status == .Verifying || self.status == .Repairing || self.status == .Extracting) && self.progress > 0) {
            hasProgress = true
        }
        
        
        return hasProgress
    }
    
    var progress: Float! {
        var progress: Float = 0
        
        if (self.status == .Verifying || self.status == .Extracting) {
            var progressString = self.actionLine!.componentsSeparatedByString(" ").last as String!
            var progressComponents = progressString.componentsSeparatedByString("/")
            
            var part = progressComponents.first!.toFloat() ?? 0
            var total = progressComponents.last!.toFloat() ?? 0
            
            progress = part / total * 100
        }
        
        return progress
    }
    
    private func stringToStatus(string: String) -> SABHistoryItemStatus! {
        var status = SABHistoryItemStatus.Queued
        
        switch (string) {
        case "Verifying":
            status = SABHistoryItemStatus.Verifying
            self.statusDescription = self.actionLine
            break;
        case "Repairing":
            status = SABHistoryItemStatus.Repairing
            break;
        case "Extracting":
            status = SABHistoryItemStatus.Extracting
            self.statusDescription = self.actionLine
            break;
        case "Running":
            status = SABHistoryItemStatus.RunningScript
            self.statusDescription = "Running script"
            break;
        case "Failed":
            status = SABHistoryItemStatus.Failed
            break;
        case "Completed":
            status = SABHistoryItemStatus.Finished
            break;
            
        default:
            status = SABHistoryItemStatus.Queued
            break;
        }
        
        return status
    }
    
}
