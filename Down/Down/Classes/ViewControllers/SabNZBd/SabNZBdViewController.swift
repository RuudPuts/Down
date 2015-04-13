//
//  SabNZBdViewController.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SabNZBdViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener, SickbeardListener {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedDescriptionLabel: UILabel!
    @IBOutlet weak var timeleftLabel: UILabel!
    @IBOutlet weak var mbRemainingLabel: UILabel!
    
    convenience init() {
        self.init(nibName: "SabNZBdViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingCellNib = UINib(nibName: "SABLoadingCell", bundle:nil)
        tableView.registerNib(loadingCellNib, forCellReuseIdentifier: "SABLoadingCell")
        
        let emtpyCellNib = UINib(nibName: "SABEmptyCell", bundle:nil)
        tableView.registerNib(emtpyCellNib, forCellReuseIdentifier: "SABEmptyCell")
        
        let itemCellNib = UINib(nibName: "SABItemCell", bundle:nil)
        tableView.registerNib(itemCellNib, forCellReuseIdentifier: "SABItemCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        serviceManager.sabNZBdService.addListener(self)
        serviceManager.sickbeardService.addListener(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        serviceManager.sabNZBdService.removeListener(self)
    }
    
    private func updateHeaderWidgets() {
        updateCurrentSpeedWidget()
        updateTimeRemainingWidget()
        updateMbRemainingWidget()
    }
    
    private func updateCurrentSpeedWidget() {
        var displaySpeed = serviceManager.sabNZBdService.currentSpeed as Float!
        var displayString = "KB/s"
        if (displaySpeed > 0) {
            if (displaySpeed > 1024) {
                displaySpeed = displaySpeed / 1024
                displayString = "MB/s"
                
                if (displaySpeed > 1024) {
                    displaySpeed = displaySpeed / 1024
                    displayString = "GB/s"
                }
            }
            
            let speedString = String(format: "%.1f", displaySpeed)
            let dotIndex = (speedString as NSString).rangeOfString(".").location
            
            let fontName = "Roboto-Light"
            let largeFont = UIFont(name: fontName, size: 50)!
            let smallFont = UIFont(name: fontName, size: 100 / 3)!
            let attributedSpeedString = NSMutableAttributedString(string: speedString)
            attributedSpeedString.addAttribute(NSFontAttributeName, value: largeFont, range: NSMakeRange(0, dotIndex - 1))
            attributedSpeedString.addAttribute(NSFontAttributeName, value: smallFont, range: NSMakeRange(dotIndex, speedString.length - dotIndex))
            
            self.speedLabel!.attributedText = attributedSpeedString
        }
        else {
            self.speedLabel!.text = "0"
        }
        self.speedDescriptionLabel!.text = displayString
    }
    
    private func updateTimeRemainingWidget() {
        self.timeleftLabel!.text = serviceManager.sabNZBdService.timeRemaining
    }
    
    private func updateMbRemainingWidget() {
        var remainingSize = serviceManager.sabNZBdService.mbLeft as Float!
        if (remainingSize > 0) {
            var remainingSizeDisplay = "MB"
            if (remainingSize < 0) {
                remainingSize = remainingSize * 1024
                remainingSizeDisplay = "KB"
            }
            else if (remainingSize > 1024) {
                remainingSize = remainingSize / 1024
                remainingSizeDisplay = "GB"
            }
            self.mbRemainingLabel!.text = String(format: "%.1f%@", remainingSize, remainingSizeDisplay)
        }
        else {
            self.mbRemainingLabel!.text = "0MB"
        }
    }
    
    // MARK: - TableView datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows : Int!
        
        if section == 0 {
            numberOfRows = serviceManager.sabNZBdService.queue.count
        }
        else {
            numberOfRows = serviceManager.sabNZBdService.history.count
        }
        
        return max(numberOfRows, 1)
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        let isEmpty: Bool!
        
        switch section {
        case 0:
            isEmpty = serviceManager.sabNZBdService.queue.count == 0
            break;
        case 1:
            isEmpty = serviceManager.sabNZBdService.history.count == 0
            break;
            
        default:
            isEmpty = true
        }
        
        return isEmpty
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: CGFloat! = 60.0
        if !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if indexPath.section == 0 {
                let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
                if (queueItem.hasProgress!) {
                    rowHeight = 66.0
                }
            }
        }
        
        return rowHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = (NSBundle.mainBundle().loadNibNamed("SABHeaderView", owner: self, options: nil) as! Array).first as SABHeaderView!

        if section == 0 {
            headerView.imageView.image = UIImage(named: "queue-icon")
        }
        else {
            headerView.imageView.image = UIImage(named: "history-icon")
        }
        headerView.textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle : String!
        
        if section == 0 {
            sectionTitle = "Queue"
        }
        else {
            sectionTitle = "History"
        }
        
        return sectionTitle
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if self.serviceManager.sabNZBdService.lastRefresh != nil {
                var emptyCell = tableView.dequeueReusableCellWithIdentifier("SABEmptyCell") as! SABEmptyCell
                
                var sectionTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)!.lowercaseString
                emptyCell.label.text = "Your \(sectionTitle) is empty."
                
                cell = emptyCell
            }
            else {
                var loadingCell = tableView.dequeueReusableCellWithIdentifier("SABLoadingCell") as! SABLoadingCell
                // For some reason this has to be called all the time
                loadingCell.activityIndicator.startAnimating()
                cell = loadingCell
            }
        }
        else {
            var itemCell = tableView.dequeueReusableCellWithIdentifier("SABItemCell") as! SABItemCell
            if (indexPath.section == 0) {
                let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
                itemCell.queueItem = queueItem
            }
            else {
                let historyItem: SABHistoryItem = serviceManager.sabNZBdService.history[indexPath.row];
                itemCell.historyItem = historyItem
            }
            cell = itemCell
        }
        
        return cell;
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        self.tableView.reloadData()
        updateHeaderWidgets()
    }
    
    func sabNZBdHistoryUpdated() {
        self.tableView.reloadData()
    }
    
    // MARK: - SickbeardListener
    
    func sickbeardHistoryUpdated() {
        self.tableView.reloadData()
    }

}
