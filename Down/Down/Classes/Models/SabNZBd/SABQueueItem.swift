//
//  SABQueueItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABQueueItem: SABItem {
    
    let timeRemaining: String!
    let totalMb: Float!
    let remainingMb: Float!
    
    init(identifier: String, filename: String, totalMb: Float, remainingMb: Float, timeRemaining: String) {
        self.timeRemaining = timeRemaining
        self.totalMb = totalMb
        self.remainingMb = remainingMb
        
        super.init(identifier: identifier, filename: filename)
    }
    
    func progress() -> Float {
        return (totalMb - remainingMb) / totalMb
    }
    
    func progressString() -> String {
        var totalSize: Float = totalMb
        var remainingSize: Float = remainingMb
        var progressString: String
        
        var totalSizeIdentifier: String = "MB"
        if (totalSize > 1000) {
            totalSizeIdentifier = "GB"
            totalSize /= 1000
        }
        
        progressString = String(format: "%.1f %@", totalSize, totalSizeIdentifier)
        
        if remainingMb != totalMb {
            var remainingSizeIdentifier: String = "MB"
            if (remainingSize > 1000) {
                remainingSizeIdentifier = "GB"
                remainingSize /= 1000
            }
            
            progressString = String(format: "%.1f %@ / %.1f %@", remainingSize, remainingSizeIdentifier, totalSize, totalSizeIdentifier)
        }
        
        return progressString
    }
   
}
