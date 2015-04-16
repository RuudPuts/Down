//
//  SABQueueItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABQueueItem: SABItem {
    
    let totalMb: Float!
    let remainingMb: Float!
    let sizeLeft: String!
    let totalSize: String!
    let timeRemaining: String!
    let progress: Float!
    var status: SABQueueItemStatus!
    
    enum SABQueueItemStatus {
        case Grabbing
        case Queued
        case Downloading
        case Downloaded
    }
    
    init(_ identifier: String, _ filename: String, _ category: String, _ statusDescription: String, _ totalMb: Float, _ remainingMb: Float, _ totalSize: String, _ sizeLeft: String, _ progress: Float, _ timeRemaining: String) {
        self.timeRemaining = timeRemaining
        self.totalMb = totalMb
        self.remainingMb = remainingMb
        self.sizeLeft = sizeLeft
        self.totalSize = totalSize
        self.progress = progress
        
        super.init(identifier, filename, category, statusDescription)
        
        self.status = stringToStatus(statusDescription)
    }
    
    var hasProgress: Bool! {
        var hasProgress = false
        if (self.status == SABQueueItemStatus.Downloading || (self.status == SABQueueItemStatus.Queued && self.progress > 0)) {
            hasProgress = true
        }
        return hasProgress
    }
    
    var progressString: String! {
        var progressString: String!
        
        switch self.status as SABQueueItemStatus {
        case .Downloaded:
            progressString = "Finished"
        case .Queued:
            progressString = self.totalSize
        case .Downloading:
            progressString = String(format: "%@ / %@", self.sizeLeft, self.totalSize);
        default:
            progressString = ""
        }
        
        return progressString
    }
    
    private func stringToStatus(string: String) -> SABQueueItemStatus! {
        var status = SABQueueItemStatus.Downloaded
        
        switch (string) {
        case "Grabbing":
            status = SABQueueItemStatus.Grabbing
        case "Queued":
            status = SABQueueItemStatus.Queued
        case "Downloading":
            status = SABQueueItemStatus.Downloading
            
        default:
            status = SABQueueItemStatus.Downloaded
        }
        
        return status
    }
   
}
