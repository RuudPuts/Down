//
//  SABQueueItemCell.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SABItemCell: DownTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    private var _historyItem: SABHistoryItem?
    private var _queueItem: SABQueueItem?
    var sabNZBdService: SabNZBdService!
    
    override func awakeFromNib() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.sabNZBdService = appDelegate.serviceManager.sabNZBdService;
    }
    
    var queueItem: SABQueueItem? {
        set {
            _queueItem = newValue
            _historyItem = nil

            titleLabel.text = _queueItem?.displayName

            var hideProgressBar = true
            var progress = 0 as Float
            if _queueItem != nil && _queueItem!.hasProgress {
                progress = _queueItem!.progress / 100
                hideProgressBar = false
            }
            progressBar.hidden = hideProgressBar
            progressBar.progress = progress
            progressLabel.text = _queueItem?.progressString
            progressLabel.textColor = UIColor.whiteColor()
            if self.sabNZBdService.paused {
                statusLabel!.text = "-"
            }
            else {
                statusLabel!.text = _queueItem?.timeRemaining
            }
            categoryLabel!.text = _queueItem?.category
        }
        get {
            return _queueItem
        }
    }
    
    var historyItem: SABHistoryItem? {
        set {
            _queueItem = nil
            _historyItem = newValue

            titleLabel.text = _historyItem?.displayName
            
            var hideProgressBar = true
            var progress = 0 as Float
            if _historyItem?.hasProgress ?? false {
                progress = _historyItem!.progress / 100
                hideProgressBar = false
            }
            progressBar.hidden = hideProgressBar
            progressBar.progress = progress
            
            progressLabel.text = _historyItem?.statusDescription
            if let historyItem = _historyItem {
                switch (historyItem.status!) {
                case .Finished:
                    progressLabel.textColor = .downGreenColor()
                case .Failed:
                    progressLabel.textColor = .downRedColor()
                default:
                    progressLabel.textColor = .whiteColor()
                }
            }
            
            var statusText = ""
            if _historyItem != nil && (_historyItem!.status == .Finished || _historyItem!.status == .Failed) {
                if let completionDate = _historyItem?.completionDate {
                    statusText = NSDateFormatter.defaultFormatter().stringFromDate(completionDate)
                }
            }
            statusLabel.text = statusText
            categoryLabel.text = _historyItem?.category
        }
        get {
            return _historyItem
        }
    }
}
