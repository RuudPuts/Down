//
//  SabNZBdViewController.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SabNZBdViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener, SickbeardListener {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerIcon: UIImageView!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedDescriptionLabel: UILabel!
    @IBOutlet weak var timeleftLabel: UILabel!
    @IBOutlet weak var mbRemainingLabel: UILabel!
    
    weak var sabNZBdService: SabNZBdService!
    weak var sickbeardService: SickbeardService!
    
    convenience init() {
        self.init(nibName: "SabNZBdViewController", bundle: nil)
        
        self.sabNZBdService = serviceManager.sabNZBdService
        self.sickbeardService = serviceManager.sickbeardService
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingCellNib = UINib(nibName: "SABLoadingCell", bundle:nil)
        tableView.registerNib(loadingCellNib, forCellReuseIdentifier: "SABLoadingCell")
        
        let emtpyCellNib = UINib(nibName: "SABEmptyCell", bundle:nil)
        tableView.registerNib(emtpyCellNib, forCellReuseIdentifier: "SABEmptyCell")
        
        let itemCellNib = UINib(nibName: "SABItemCell", bundle:nil)
        tableView.registerNib(itemCellNib, forCellReuseIdentifier: "SABItemCell")
        
        let moreHistoryCellNib = UINib(nibName: "SABMoreHistoryCell", bundle: nil)
        tableView.registerNib(moreHistoryCellNib, forCellReuseIdentifier: "SABMoreHistoryCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if animated {
            animateIcon(true)
        }
        
        self.sabNZBdService.addListener(self)
        self.sickbeardService.addListener(self)
    }
    
//    override func viewDidAppear(animated: Bool) {
//        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
//            self.animateIcon(false)
//        }
//    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.sabNZBdService.removeListener(self)
    }
    
    private func animateIcon(animateOut: Bool) {
        self.headerIcon.horizontalCenterConstraint?.constant = UIScreen.mainScreen().bounds.size.width / 2 - 75 / 2 - 32
        self.headerIcon.widthConstraint?.constant = 75;
        self.headerIcon.heightConstraint?.constant = 20;
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.headerView.layoutIfNeeded()
        })
    }
    
    // MARK: - Header widgets
    
    private func updateHeaderWidgets() {
        updateCurrentSpeedWidget()
        updateTimeRemainingWidget()
        updateMbRemainingWidget()
    }
    
    private func updateCurrentSpeedWidget() {
        var displaySpeed = self.sabNZBdService.currentSpeed as Float!
        var displayString = "KB/s"
        
        if displaySpeed > 1024 {
            displaySpeed = displaySpeed / 1024
            displayString = "MB/s"
            
            if (displaySpeed > 1024) {
                displaySpeed = displaySpeed / 1024
                displayString = "GB/s"
            }
        }
        
        if displaySpeed > 0 {
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
        self.timeleftLabel!.text = self.sabNZBdService.timeRemaining
    }
    
    private func updateMbRemainingWidget() {
        var remainingSize = self.sabNZBdService.mbLeft as Float!
            var remainingSizeDisplay = "MB"
            if (remainingSize < 0) {
                remainingSize = remainingSize * 1024
                remainingSizeDisplay = "KB"
            }
            else if (remainingSize > 1024) {
                remainingSize = remainingSize / 1024
                remainingSizeDisplay = "GB"
            }
        
        if (remainingSize > 0) {
            self.mbRemainingLabel!.text = String(format: "%.1f%@", remainingSize, remainingSizeDisplay)
        }
        else {
            self.mbRemainingLabel!.text = String(format: "%.0f%@", remainingSize, remainingSizeDisplay)
        }
    }
    
    // MARK: - TableView datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 1
        
        if section == 0 {
            numberOfRows = sabNZBdService.queue.count
        }
        else {
            numberOfRows = min(sabNZBdService.history.count, 20)
            if (!sabNZBdService.history.isEmpty) {
                numberOfRows += 1
            }
        }
        
        return max(numberOfRows, 1)
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        var isEmpty = true
        
        if section == 0 {
            isEmpty = serviceManager.sabNZBdService.queue.count == 0
        }
        else {
            isEmpty = serviceManager.sabNZBdService.history.count == 0
        }
        
        return isEmpty
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: Float = 60
        if !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if indexPath.section == 0 {
                let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
                if (queueItem.hasProgress!) {
                    rowHeight = 66.0
                }
            }
            else if indexPath.row < serviceManager.sabNZBdService.history.count - 1 {
                let historyItem: SABHistoryItem = serviceManager.sabNZBdService.history[indexPath.row];
                if (historyItem.hasProgress!) {
                    rowHeight = 66.0
                }
            }
        }
        
        return CGFloat(rowHeight)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = (NSBundle.mainBundle().loadNibNamed("SABHeaderView", owner: self, options: nil) as Array).first as! SABHeaderView

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
        var sectionTitle: String?
        
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
        
        let sabNZBdService = self.serviceManager.sabNZBdService
        if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if sabNZBdService.lastRefresh != nil {
                var emptyCell = tableView.dequeueReusableCellWithIdentifier("SABEmptyCell", forIndexPath: indexPath) as! SABEmptyCell
                
                var sectionTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)!.lowercaseString
                emptyCell.label.text = "Your \(sectionTitle) is empty."
                
                cell = emptyCell
            }
            else {
                var loadingCell = tableView.dequeueReusableCellWithIdentifier("SABLoadingCell", forIndexPath: indexPath) as! SABLoadingCell
                // For some reason this has to be called all the time
                loadingCell.activityIndicator.startAnimating()
                cell = loadingCell
            }
        }
        else if indexPath.section == 1 && indexPath.row == serviceManager.sabNZBdService.history.count {
            var historyCell = tableView.dequeueReusableCellWithIdentifier("SABMoreHistoryCell", forIndexPath: indexPath) as! SABMoreHistoryCell
            cell = historyCell
        }
        else {
            var itemCell = tableView.dequeueReusableCellWithIdentifier("SABItemCell", forIndexPath: indexPath) as! SABItemCell
            if indexPath.section == 0 {
                let queueItem: SABQueueItem = sabNZBdService.queue[indexPath.row];
                itemCell.queueItem = queueItem
            }
            else {
                let historyItem: SABHistoryItem = sabNZBdService.history[indexPath.row];
                itemCell.historyItem = historyItem
            }
            cell = itemCell
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == serviceManager.sabNZBdService.history.count {
            var historyViewController = SabNZBdHistoryViewController()
            animateIcon(true)
            self.navigationController!.pushViewController(historyViewController, animated: true)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
