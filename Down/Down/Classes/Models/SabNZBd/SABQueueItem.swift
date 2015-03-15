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
    let status: SABQueueItemStatus!
    
    enum SABQueueItemStatus {
        case Queued
        case Downloading
        case Downloaded
    }
    
    init(identifier: String, filename: String, category: String, totalMb: Float, remainingMb: Float, totalSize: String, sizeLeft: String, progress: Float, timeRemaining: String) {
        self.timeRemaining = timeRemaining
        self.totalMb = totalMb
        self.remainingMb = remainingMb
        self.sizeLeft = sizeLeft
        self.totalSize = totalSize
        self.progress = progress
        
        if (totalMb == remainingMb) {
            self.status = SABQueueItemStatus.Queued
        } else if (remainingMb == 0) {
            self.status = SABQueueItemStatus.Downloaded
        }
        else {
            self.status = SABQueueItemStatus.Downloading
        }
        
        super.init(identifier: identifier, filename: filename, category: category)
    }
    
    func progressString() -> String {
        var progressString: String!
        
        switch self.status as SABQueueItemStatus {
        case .Downloaded:
            progressString = "Finished"
        case .Queued:
            progressString = self.totalSize
        case .Downloading:
            progressString = String(format: "%@ / %@", self.sizeLeft, self.totalSize);
        }
        return progressString
    }
   
}
