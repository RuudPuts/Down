//
//  SABHistoryItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

open class SABHistoryItem: SABItem {
    
    let title: String!
    open let size: String!
    var actionLine: String?
    open var status: SABHistoryItemStatus?
    open var completionDate: Date?
    
    public enum SABHistoryItemStatus {
        case queued
        case verifying
        case repairing
        case extracting
        case runningScript
        case failed
        case finished
    }
    
    init(_ identifier: String, _ title: String, _ category: String, _ nzbName: String, _ size: String, _ statusDescription: String, _ actionLine: String, _ completionDate: Date) {
        self.size = size
        self.title = title
        self.actionLine = actionLine
        self.completionDate = completionDate
        
        super.init(identifier, category, nzbName, statusDescription)
        
        self.status = stringToStatus(statusDescription)
    }
    
    internal func update(_ category: String, _ statusDescription: String, _ actionLine: String, _ completionDate: Date) {
        self.category = category
        self.statusDescription = statusDescription
        self.actionLine = actionLine
        self.completionDate = completionDate
        self.status = stringToStatus(statusDescription)
    }
    
    open var hasProgress: Bool {
        var hasProgress = false
        if (self.status == .verifying || self.status == .repairing || self.status == .extracting) && self.progress > 0 {
            hasProgress = true
        }
        
        
        return hasProgress
    }
    
    open var progress: Float {
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
    
    fileprivate func stringToStatus(_ string: String) -> SABHistoryItemStatus {
        var status = SABHistoryItemStatus.queued
        
        switch (string) {
        case "Verifying":
            status = SABHistoryItemStatus.verifying
            statusDescription = actionLine
            break
        case "Repairing":
            status = SABHistoryItemStatus.repairing
            break
        case "Extracting":
            status = SABHistoryItemStatus.extracting
            statusDescription = actionLine
            break
        case "Running":
            status = SABHistoryItemStatus.runningScript
            statusDescription = "Running script"
            break
        case "Failed":
            status = SABHistoryItemStatus.failed
            break
        case "Completed":
            status = SABHistoryItemStatus.finished
            break
            
        default:
            status = SABHistoryItemStatus.queued
            break
        }
        
        return status
    }
    
}
