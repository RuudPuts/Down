//
//  SabNZBdViewController.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SabNZBdViewController: DownViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener, SickbeardListener {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerIcon: UIImageView!
    @IBOutlet weak var widgetsContainer: UIView!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedDescriptionLabel: UILabel!
    @IBOutlet weak var timeleftLabel: UILabel!
    @IBOutlet weak var mbRemainingLabel: UILabel!
    
    weak var sabNZBdService: SabNZBdService!
    weak var sickbeardService: SickbeardService!
    
    private let kMaxHistoryDisplayCount = 20
    
    convenience init() {
        self.init(nibName: "SabNZBdViewController", bundle: nil)
        title = "SABnzbd"
        
        sabNZBdService = serviceManager.sabNZBdService
        sickbeardService = serviceManager.sickbeardService
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingCellNib = UINib(nibName: "DownActivityCell", bundle:nil)
        tableView!.registerNib(loadingCellNib, forCellReuseIdentifier: "DownActivityCell")
        
        let emtpyCellNib = UINib(nibName: "DownEmptyCell", bundle:nil)
        tableView!.registerNib(emtpyCellNib, forCellReuseIdentifier: "DownEmptyCell")
        
        let itemCellNib = UINib(nibName: "SABItemCell", bundle:nil)
        tableView!.registerNib(itemCellNib, forCellReuseIdentifier: "SABItemCell")
        
        let moreHistoryCellNib = UINib(nibName: "DownTextCell", bundle: nil)
        tableView!.registerNib(moreHistoryCellNib, forCellReuseIdentifier: "DownTextCell")
        
        headerView.backgroundColor = .downSabNZBdColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sabNZBdService.addListener(self)
        sickbeardService.addListener(self)
        
        tableView!.reloadData()
        updateHeader()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        sabNZBdService.removeListener(self)
        sickbeardService.removeListener(self)
    }
    
    // MARK: - Header widgets
    
    private func updateHeader() {
        let expandedHeaderHeight: CGFloat = 190
        let collapsedHeaderHeight: CGFloat = 100
        
        let queueEmpty = sabNZBdService.queue.isEmpty
        let headerExpanded = headerView.heightConstraint?.constant == expandedHeaderHeight
        
        var updateHeader = false
        var expandHeader = false
        
        if queueEmpty && headerExpanded {
            updateHeader = true
        }
        else if !queueEmpty && !headerExpanded {
            updateHeader = true
            expandHeader = true
        }
        
        if updateHeader {
            headerView.heightConstraint?.constant = expandHeader ? expandedHeaderHeight : collapsedHeaderHeight
            
            UIView.animateWithDuration(0.2, delay: expandHeader ? 0.15 : 0.0, options: .TransitionNone, animations: {
                self.widgetsContainer.alpha = expandHeader ? 1 : 0
                }, completion: nil)
            
            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutSubviews()
                self.headerView.layoutSubviews()
            })
        }
        
        updateHeaderWidgets()
    }
    
    private func updateHeaderWidgets() {
        updateCurrentSpeedWidget()
        updateTimeRemainingWidget()
        updateMbRemainingWidget()
    }
    
    private func updateCurrentSpeedWidget() {
        var displaySpeed = sabNZBdService.currentSpeed ?? 0
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
        self.timeleftLabel!.text = sabNZBdService.timeRemaining ?? "-"
    }
    
    private func updateMbRemainingWidget() {
        self.mbRemainingLabel!.text = String(fromMB: sabNZBdService.mbLeft ?? 0)
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
            numberOfRows = min(sabNZBdService.history.count, kMaxHistoryDisplayCount)
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
                if (queueItem.hasProgress) {
                    rowHeight = 66.0
                }
            }
            else if indexPath.row < serviceManager.sabNZBdService.history.count - 1 {
                let historyItem: SABHistoryItem = serviceManager.sabNZBdService.history[indexPath.row];
                if (historyItem.hasProgress) {
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
        let headerView = (NSBundle.mainBundle().loadNibNamed("SABHeaderView", owner: self, options: nil) as Array).first as! SABHeaderView

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
                let emptyCell = tableView.dequeueReusableCellWithIdentifier("DownEmptyCell", forIndexPath: indexPath) as! DownEmptyCell
                
                let sectionTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)!.lowercaseString
                emptyCell.label.text = "Your \(sectionTitle) is empty."
                cell = emptyCell
            }
            else {
                let loadingCell = tableView.dequeueReusableCellWithIdentifier("DownActivityCell", forIndexPath: indexPath) as! DownTableViewCell
                loadingCell.setCellType(.SabNZBd)
                sabNZBdService.checkHostReachability({ reachable, _ in
                    if !reachable {
                        // Host is not reachable
                        loadingCell.label?.text = "Host seems down..."
                    }
                    else {
                        loadingCell.label?.text = "Loading..."
                    }
                })
                
                cell = loadingCell
            }
        }
        else if indexPath.section == 1 && indexPath.row == kMaxHistoryDisplayCount {
            let historyCell = tableView.dequeueReusableCellWithIdentifier("DownTextCell", forIndexPath: indexPath) as! DownTextCell
            historyCell.setCellType(.SabNZBd)
            historyCell.label?.text = "Full history"
            cell = historyCell
        }
        else {
            let itemCell = tableView.dequeueReusableCellWithIdentifier("SABItemCell", forIndexPath: indexPath) as! SABItemCell
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
        if indexPath.section == 1 && indexPath.row == kMaxHistoryDisplayCount {
            let historyViewController = SabNZBdHistoryViewController()
            self.navigationController!.pushViewController(historyViewController, animated: true)
        }
        else if !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            var item: SABItem
            if indexPath.section == 0 {
                item = sabNZBdService.queue[indexPath.row];
            }
            else {
                item = sabNZBdService.history[indexPath.row];
            }
            
            let detailViewController = SabNZBdDetailViewController(sabItem: item)
            navigationController!.pushViewController(detailViewController, animated: true)
        }
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var item: SABItem
        if indexPath.section == 0 {
            item = sabNZBdService.queue[indexPath.row]
        }
        else {
            item = sabNZBdService.history[indexPath.row]
        }
        sabNZBdService.deleteItem(item)
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        tableView!.reloadData()
        updateHeader()
    }
    
    func sabNZBdHistoryUpdated() {
        tableView!.reloadData()
    }
    
    func sabNZBDFullHistoryFetched() { }
    func willRemoveSABItem(sabItem: SABItem) { }
    
    // MARK: - SickbeardListener
    
    func sickbeardHistoryUpdated() {
        tableView!.reloadData()
    }
    
    func sickbeardFutureUpdated() {
        tableView!.reloadData()
    }

}
