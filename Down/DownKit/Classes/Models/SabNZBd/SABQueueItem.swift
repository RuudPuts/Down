//
//  SABQueueItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

open class SABQueueItem: SABItem {
    
    let totalMb: Float!
    var remainingMb: Float!
    open var timeRemaining: TimeInterval!
    open var progress: Float!
    var status: SABQueueItemStatus!
    
    enum SABQueueItemStatus {
        case grabbing
        case queued
        case downloading
        case downloaded
    }
    
    init(_ identifier: String, _ category: String, _ nzbName: String, _ statusDescription: String, _ totalMb: Float, _ remainingMb: Float, _ progress: Float, _ timeRemaining: TimeInterval) {
        self.timeRemaining = timeRemaining
        self.totalMb = totalMb
        self.remainingMb = remainingMb
        self.progress = progress
        
        super.init(identifier, category, nzbName, statusDescription)
        
        self.status = stringToStatus(statusDescription)
    }
    
    internal func update(_ nzbName: String, _ statusDescription: String, _ remainingMb: Float, _ progress: Float, _ timeRemaining: TimeInterval) {
        self.nzbName = nzbName
        self.remainingMb = remainingMb
        self.statusDescription = statusDescription
        self.status = stringToStatus(statusDescription)
        self.progress = progress
        self.timeRemaining = timeRemaining
    }
    
    open var downloadedMb: Float {
        return max(0.0, self.totalMb - self.remainingMb)
    }
    
    open var hasProgress: Bool {
        var hasProgress = false
        if self.status == SABQueueItemStatus.downloading || (self.status == SABQueueItemStatus.queued && self.progress > 0) {
            hasProgress = true
        }
        return hasProgress
    }
    
    open var progressString: String! {
        var progressString: String!
        
        switch status as SABQueueItemStatus {
        case .downloaded:
            progressString = "Finished"
        case .queued:
            progressString = String(fromMB:self.totalMb)
        case .downloading:
            progressString = String(format: "%@ / %@", String(fromMB:self.downloadedMb), String(fromMB:self.totalMb));
        default:
            progressString = ""
        }
        
        return progressString
    }
    
    fileprivate func stringToStatus(_ string: String) -> SABQueueItemStatus! {
        var status = SABQueueItemStatus.downloaded
        
        switch (string) {
        case "Grabbing":
            status = SABQueueItemStatus.grabbing
        case "Queued":
            status = SABQueueItemStatus.queued
        case "Downloading":
            status = SABQueueItemStatus.downloading
            
        default:
            status = SABQueueItemStatus.downloaded
        }
        
        return status
    }
   
}
