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

    fileprivate var _historyItem: SABHistoryItem?
    fileprivate var _queueItem: SABQueueItem?
    
    var queueItem: SABQueueItem? {
        set {
            _queueItem = newValue
            _historyItem = nil

            titleLabel.text = _queueItem?.displayName

            var hideProgressBar = true
            var progress = 0.0
            if _queueItem != nil && _queueItem!.hasProgress {
                progress = _queueItem!.progress / 100
                hideProgressBar = false
            }
            progressBar.isHidden = hideProgressBar
            progressBar.progress = Float(progress)
            progressLabel.text = _queueItem?.progressString
            progressLabel.textColor = UIColor.white
            if SabNZBdService.shared.paused {
                statusLabel!.text = "-"
            }
            else {
                // TODO: DateFormatter?
                var secondsRemaining = _queueItem?.timeRemaining ?? 0
                
                let hoursRemaining = floor(secondsRemaining / 3600)
                secondsRemaining -= hoursRemaining * 3600
                
                let minutesRemaining = floor(secondsRemaining / 60)
                secondsRemaining -= minutesRemaining * 60
                
                let timeRemainingString = String(format:"%01d:%02d:%02d", Int(hoursRemaining), Int(minutesRemaining), Int(secondsRemaining))
                statusLabel!.text = timeRemainingString
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
            var progress = 0.0
            if _historyItem?.hasProgress ?? false {
                progress = _historyItem!.progress / 100
                hideProgressBar = false
            }
            progressBar.isHidden = hideProgressBar
            progressBar.progress = Float(progress)
            
            progressLabel.text = _historyItem?.statusDescription()
            if let historyItem = _historyItem {
                switch (historyItem.status) {
                case .completed:
                    progressLabel.textColor = .downGreenColor()
                case .failed:
                    progressLabel.textColor = .downRedColor()
                default:
                    progressLabel.textColor = .white
                }
            }
            
            var statusText = ""
            if _historyItem != nil && (_historyItem!.status == .completed || _historyItem!.status == .failed) {
                if let completionDate = _historyItem?.completionDate {
                    statusText = completionDate.dateString
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
