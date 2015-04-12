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

            if _queueItem?.sickbeardEntry != nil {
                titleLabel.text = _queueItem?.sickbeardEntry!.displayName
            }
            else {
                titleLabel!.text = _queueItem?.displayName
            }

            var hideProgressBar = true
            var progress = 0 as Float
            if (_queueItem != nil && _queueItem!.hasProgress!) {
                progress = _queueItem!.progress / 100
                hideProgressBar = false
            }
            progressBar!.hidden = hideProgressBar
            progressBar!.progress = progress
            progressLabel!.text = _queueItem?.progressString
            if (self.sabNZBdService.paused!) {
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

            if _historyItem?.sickbeardEntry != nil {
                titleLabel.text = _historyItem?.sickbeardEntry!.displayName
            }
            else {
                titleLabel!.text = _historyItem?.displayName
            }
    //        progressBar!.progress = historyItem.progress
            progressLabel!.text = _historyItem?.statusDescription
            if (_historyItem != nil) {
                switch (_historyItem!.status!) {
                case .Finished:
                    progressLabel.textColor = UIColor.downGreenColor()
                case .Failed:
                    progressLabel.textColor = UIColor.downRedColor()
                default:
                    progressLabel.textColor = UIColor.whiteColor()
                }
            }
            
            statusLabel!.text = _historyItem?.size
            progressBar!.progress = 0
            progressBar!.hidden = true
            
            categoryLabel!.text = _historyItem?.category
        }
        get {
            return _historyItem
        }
    }

}
