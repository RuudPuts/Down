//
//  SABQueueItemCell.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var queueItem: SABQueueItem?
    var historyItem: SABHistoryItem?
    
    internal func setQueueItem(queueItem: SABQueueItem) {
        self.historyItem = nil
        self.queueItem = queueItem
        
        titleLabel!.text = queueItem.displayName
        
        progressBar!.progress = queueItem.progress
        let hideProgressBar = queueItem.status == SABQueueItem.SABQueueItemStatus.Downloading
        progressBar!.hidden = hideProgressBar
        progressLabel!.text = queueItem.progressDescription
        statusLabel!.text = queueItem.timeRemaining
        categoryLabel!.text = queueItem.category
    }
    
    func setHistoryItem(historyItem: SABHistoryItem) {
        self.queueItem = nil
        self.historyItem = historyItem
        
        titleLabel!.text = historyItem.displayName
//        progressBar!.progress = historyItem.progress
        progressLabel!.text = historyItem.statusString
        switch (historyItem.status! as SABHistoryItem.SABHistoryItemStatus) {
        case .Finished:
            progressLabel.textColor = UIColor.downGreenColor()
        case .Failed:
            progressLabel.textColor = UIColor.downRedColor()
        default:
            progressLabel.textColor = UIColor.whiteColor()
        }
        
        statusLabel!.text = historyItem.size
        progressBar!.progress = 0
        progressBar!.hidden = true
        
        categoryLabel!.text = historyItem.category
    }
    
}
