//
//  SABQueueItemCell.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABQueueItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var queueItem: SABQueueItem?
    
    internal func setQueueItem(queueItem: SABQueueItem) {
        self.queueItem = queueItem
        
        titleLabel!.text = queueItem.filename
        progressBar!.progress = queueItem.progress()
        progressLabel!.text = queueItem.progressString()
        timeRemainingLabel!.text = queueItem.timeRemaining
        categoryLabel!.text = queueItem.category
    }
    
}
