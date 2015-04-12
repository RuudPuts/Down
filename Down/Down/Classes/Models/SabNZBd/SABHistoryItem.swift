//
//  SABHistoryItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABHistoryItem: SABItem {
   
    let size: String!
    var status: SABHistoryItemStatus?
    
    internal enum SABHistoryItemStatus {
        case Queued
        case Verifying
        case Repairing
        case Extracting
        case RunningScript
        case Failed
        case Finished
    }
    
    init(identifier: String, title: String, filename: String, category: String, size: String, statusDescription: String) {
        self.size = size
        
        super.init(identifier: identifier, title: title, filename: filename, category: category, statusDescription: statusDescription)
        
        self.status = stringToStatus(statusDescription)
    }
    
    private func stringToStatus(string: String) -> SABHistoryItemStatus! {
        var status = SABHistoryItemStatus.Queued
        
        switch (string) {
        case "Verifying":
            status = SABHistoryItemStatus.Verifying
        case "Repairing":
            status = SABHistoryItemStatus.Repairing
        case "Extracting":
            status = SABHistoryItemStatus.Extracting
        case "Running":
            status = SABHistoryItemStatus.RunningScript
        case "Failed":
            status = SABHistoryItemStatus.Failed
        case "Completed":
            status = SABHistoryItemStatus.Finished
            
        default:
            status = SABHistoryItemStatus.Queued
        }
        
        return status
    }
    
}
