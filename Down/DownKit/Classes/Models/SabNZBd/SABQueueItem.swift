//
//  SABQueueItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

public class SABQueueItem: SABItem {
    
    var totalMb: Double!
    var remainingMb: Double!
    public var timeRemaining: TimeInterval!
    public var progress: Double!

    init(_ identifier: String, _ category: String, _ nzbName: String, _ statusDescription: String,
         _ totalMb: Double, _ remainingMb: Double, _ progress: Double, _ timeRemaining: TimeInterval) {
        self.timeRemaining = timeRemaining
        self.totalMb = totalMb
        self.remainingMb = remainingMb
        self.progress = progress
        
        super.init(identifier, category, nzbName, statusDescription)
    }

    // swiftlint:disable function_parameter_count
    internal func update(_ nzbName: String, _ statusString: String, _ totalMb: Double,
                         _ remainingMb: Double, _ progress: Double, _ timeRemaining: TimeInterval) {
        self.nzbName = nzbName
        self.totalMb = totalMb
        self.remainingMb = remainingMb
        self.statusString = statusString
        self.progress = progress
        self.timeRemaining = timeRemaining
    }
    
    public var downloadedMb: Double {
        return max(0.0, self.totalMb - self.remainingMb)
    }
    
    public var hasProgress: Bool {
        var hasProgress = false
        if self.status == .downloading || (self.status == .queued && self.progress > 0) {
            hasProgress = true
        }
        return hasProgress
    }
    
    public var progressString: String! {
        var progressString: String!
        
        switch status {
        case .queued:
            progressString = String(fromMB: self.totalMb)
        case .downloading:
            progressString = String(format: "%@ / %@", String(fromMB: self.downloadedMb), String(fromMB: self.totalMb))
        default:
            progressString = ""
        }
        
        return progressString
    }
}
