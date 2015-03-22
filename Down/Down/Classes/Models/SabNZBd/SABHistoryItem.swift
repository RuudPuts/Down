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
    let statusString: String!
    let status: SABHistoryItemStatus?
    
    internal enum SABHistoryItemStatus {
        case Queued
        case Verifying
        case Repairing
        case Unpacking
        case RunningScript
        case Failed
        case Finished
    }
    
    init(identifier: String, filename: String, category: String, size: String, status: String) {
        self.size = size
        
        super.init(identifier: identifier, filename: filename, category: category)
        
        self.statusString = status
        self.status = stringToStatus(status)
    }
    
    private func stringToStatus(string: String) -> SABHistoryItemStatus! {
        var status = SABHistoryItemStatus.Queued
        
        switch (string) {
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
