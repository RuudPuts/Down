//
//  SABQueueItemCell.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABItemCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
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

            if let sickbeardEntry = _queueItem?.sickbeardEntry {
                titleLabel.text = sickbeardEntry.displayName
            }
            else {
                titleLabel.text = _queueItem?.displayName
            }

            var hideProgressBar = true
            var progress = 0 as Float
            if _queueItem != nil && _queueItem!.hasProgress! {
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

            if let sickbeardEntry = _queueItem?.sickbeardEntry {
                titleLabel.text = sickbeardEntry.displayName
            }
            else {
                titleLabel.text = _historyItem?.displayName
            }
            
            var hideProgressBar = true
            var progress = 0 as Float
            if (_historyItem != nil && _historyItem!.hasProgress!) {
                progress = _historyItem!.progress / 100
                hideProgressBar = false
            }
            progressBar.hidden = hideProgressBar
            progressBar.progress = progress
            
            progressLabel.text = _historyItem?.statusDescription
            if let historyItem = _historyItem {
                switch (historyItem.status!) {
                case .Finished:
                    progressLabel.textColor = UIColor.downGreenColor()
                case .Failed:
                    progressLabel.textColor = UIColor.downRedColor()
                default:
                    progressLabel.textColor = UIColor.whiteColor()
                }
            }
            
            statusLabel.text = _historyItem?.size
            categoryLabel.text = _historyItem?.category
        }
        get {
            return _historyItem
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if (highlighted) {
            self.containerView.backgroundColor = UIColor.downSabNZBdColor().colorWithAlphaComponent(0.15)
        }
        else {
            self.containerView.backgroundColor = UIColor.downLightGreyColor()
        }
    }

}
