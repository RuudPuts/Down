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
            _historyItem = nil
            self.queueItem = newValue

            if newValue?.sickbeardEntry != nil {
                titleLabel.text = newValue?.sickbeardEntry!.displayName
            }
            else {
                titleLabel!.text = newValue?.displayName
            }

            progressBar!.progress = newValue?.progress ?? 0 / 100
            progressBar!.hidden = newValue?.hasProgress ?? true
            progressLabel!.text = newValue?.progressDescription
            if (self.sabNZBdService.paused!) {
                statusLabel!.text = "-"
            }
            else {
                statusLabel!.text = newValue?.timeRemaining
            }
            categoryLabel!.text = newValue?.category
        }
        get {
            return _queueItem
        }
    }
    
    var historyItem: SABHistoryItem? {
        set {
            _queueItem = nil

            if newValue?.sickbeardEntry != nil {
                titleLabel.text = newValue?.sickbeardEntry!.displayName
            }
            else {
                titleLabel!.text = newValue?.displayName
            }
    //        progressBar!.progress = historyItem.progress
            progressLabel!.text = newValue?.statusDescription
            if (newValue != nil) {
                switch (newValue!.status!) {
                case .Finished:
                    progressLabel.textColor = UIColor.downGreenColor()
                case .Failed:
                    progressLabel.textColor = UIColor.downRedColor()
                default:
                    progressLabel.textColor = UIColor.whiteColor()
                }
            }
            
            statusLabel!.text = newValue?.size
            progressBar!.progress = 0
            progressBar!.hidden = true
            
            categoryLabel!.text = newValue?.category
        }
        get {
            return _historyItem
        }
    }

}
