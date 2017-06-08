//
//  SabNZBdViewController.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import Rswift

class SabNZBdViewController: DownRootViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener, SickbeardListener {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerIcon: UIImageView!
    @IBOutlet weak var widgetsContainer: UIView!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedDescriptionLabel: UILabel!
    @IBOutlet weak var timeleftLabel: UILabel!
    @IBOutlet weak var mbRemainingLabel: UILabel!
    
    fileprivate let kMaxHistoryDisplayCount = 20
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "SABnzbd"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingCellNib = UINib(nibName: "DownActivityCell", bundle:nil)
        tableView!.register(loadingCellNib, forCellReuseIdentifier: "DownActivityCell")
        
        let emtpyCellNib = UINib(nibName: "DownEmptyCell", bundle:nil)
        tableView!.register(emtpyCellNib, forCellReuseIdentifier: "DownEmptyCell")
        
        let itemCellNib = UINib(nibName: "SABItemCell", bundle:nil)
        tableView!.register(itemCellNib, forCellReuseIdentifier: "SABItemCell")
        
        let moreHistoryCellNib = UINib(nibName: "DownTextCell", bundle: nil)
        tableView!.register(moreHistoryCellNib, forCellReuseIdentifier: "DownTextCell")
        
        headerView.backgroundColor = .downSabNZBdColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SabNZBdService.shared.addListener(self)
        SickbeardService.shared.addListener(self)
        
        tableView!.reloadData()
        updateHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SabNZBdService.shared.removeListener(self)
        SickbeardService.shared.removeListener(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView!.indexPathForSelectedRow , segue.identifier == "SabNZBdDetail" {
            var selectedItem: SABItem
            if (indexPath as NSIndexPath).section == 0 {
                selectedItem = SabNZBdService.shared.queue[indexPath.row];
            }
            else {
                selectedItem = SabNZBdService.shared.history[indexPath.row];
            }
            
            let detailViewController = segue.destination as! SabNZBdDetailViewController
            detailViewController.sabItem = selectedItem
        }
    }
    
    // MARK: - Header widgets
    
    fileprivate func updateHeader() {
        let expandedHeaderHeight: CGFloat = 190
        let collapsedHeaderHeight: CGFloat = 100
        
        let queueEmpty = SabNZBdService.shared.queue.isEmpty
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
            
            UIView.animate(withDuration: 0.2, delay: expandHeader ? 0.15 : 0.0, options: UIViewAnimationOptions(), animations: {
                self.widgetsContainer.alpha = expandHeader ? 1 : 0
                }, completion: nil)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutSubviews()
                self.headerView.layoutSubviews()
            })
        }
        
        updateHeaderWidgets()
    }
    
    fileprivate func updateHeaderWidgets() {
        updateCurrentSpeedWidget()
        updateTimeRemainingWidget()
        updateMbRemainingWidget()
    }
    
    fileprivate func updateCurrentSpeedWidget() {
        var displaySpeed = SabNZBdService.shared.currentSpeed ?? 0
        // TODO: Use Stefan's awesome number thingy
        var displayString = "KB/s"
        
        if displaySpeed > 1024 {
            displaySpeed = displaySpeed / 1024
            displayString = "MB/s"
            
            if displaySpeed > 1024 {
                displaySpeed = displaySpeed / 1024
                displayString = "GB/s"
            }
        }
        
        if displaySpeed > 0 {
            let speedString = String(format: "%.1f", displaySpeed)
            let dotIndex = (speedString as NSString).range(of: ".").location
            
            let largeFont = R.font.robotoLight(size: 50)!
            let smallFont = R.font.robotoLight(size: 100 / 3)!
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
    
    fileprivate func updateTimeRemainingWidget() {
        self.timeleftLabel!.text = SabNZBdService.shared.timeRemaining ?? "-"
    }
    
    fileprivate func updateMbRemainingWidget() {
        self.mbRemainingLabel!.text = String(fromMB: SabNZBdService.shared.mbLeft ?? 0)
    }
    
    // MARK: - TableView datasource
    
    // TODO: Implement some kind of row type enum (queue, history, fullhistory)
    func isFullHistoryIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row == min(kMaxHistoryDisplayCount, SabNZBdService.shared.history.count)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 1
        
        if section == 0 {
            numberOfRows = SabNZBdService.shared.queue.count
        }
        else {
            numberOfRows = min(SabNZBdService.shared.history.count, kMaxHistoryDisplayCount)
            if !SabNZBdService.shared.history.isEmpty {
                numberOfRows += 1
            }
        }
        
        return max(numberOfRows, 1)
    }
    
    func tableView(_ tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        var isEmpty = true
        
        if section == 0 {
            isEmpty = SabNZBdService.shared.queue.count == 0
        }
        else {
            isEmpty = SabNZBdService.shared.history.count == 0
        }
        
        return isEmpty
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: Float = 60
        if !self.tableView(tableView, isSectionEmtpy: (indexPath as NSIndexPath).section) {
            if (indexPath as NSIndexPath).section == 0 {
                let queueItem = SabNZBdService.shared.queue[indexPath.row];
                if queueItem.hasProgress {
                    rowHeight = 66.0
                }
            }
            else if indexPath.row < SabNZBdService.shared.history.count - 1 {
                let historyItem = SabNZBdService.shared.history[indexPath.row];
                if historyItem.hasProgress {
                    rowHeight = 66.0
                }
            }
        }
        
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("SABHeaderView", owner: self, options: nil)!.first as! SABHeaderView

        if section == 0 {
            headerView.imageView.image = R.image.queueIcon()
        }
        else {
            headerView.imageView.image = R.image.historyIcon()
        }
        headerView.textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle: String?
        
        if section == 0 {
            sectionTitle = "Queue"
        }
        else {
            sectionTitle = "History"
        }
        
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if self.tableView(tableView, isSectionEmtpy: (indexPath as NSIndexPath).section) {
            if SabNZBdService.shared.lastRefresh != nil {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "DownEmptyCell", for: indexPath) as! DownEmptyCell
                
                let sectionTitle = self.tableView(tableView, titleForHeaderInSection: (indexPath as NSIndexPath).section)!.lowercased()
                emptyCell.label?.text = "Your \(sectionTitle) is empty."
                cell = emptyCell
            }
            else {
                let loadingCell = tableView.dequeueReusableCell(withIdentifier: "DownActivityCell", for: indexPath) as! DownTableViewCell
                loadingCell.setCellType(.SabNZBd)
                
                
                loadingCell.label?.text = "Loading..."
                SabNZBdRequest.ping { reachable in
                    if !reachable {
                        loadingCell.label?.text = "Host seems down..."
                    }   
                }
                
                cell = loadingCell
            }
        }
        else if isFullHistoryIndexPath(indexPath) {
            let historyCell = tableView.dequeueReusableCell(withIdentifier: "DownTextCell", for: indexPath) as! DownTextCell
            historyCell.setCellType(.SabNZBd)
            historyCell.label?.text = "Full history"
            cell = historyCell
        }
        else {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "SABItemCell", for: indexPath) as! SABItemCell
            if (indexPath as NSIndexPath).section == 0 {
                let queueItem: SABQueueItem = SabNZBdService.shared.queue[indexPath.row];
                itemCell.queueItem = queueItem
            }
            else {
                let historyItem: SABHistoryItem = SabNZBdService.shared.history[indexPath.row];
                itemCell.historyItem = historyItem
            }
            cell = itemCell
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFullHistoryIndexPath(indexPath) {
            performSegue(withIdentifier: "SabNZBdHistory", sender: nil)
        }
        else if !self.tableView(tableView, isSectionEmtpy: (indexPath as NSIndexPath).section) {
            performSegue(withIdentifier: "SabNZBdDetail", sender: nil)
        }
        
        self.tableView!.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isFullHistoryIndexPath(indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var item: SABItem
        if (indexPath as NSIndexPath).section == 0 {
            item = SabNZBdService.shared.queue[indexPath.row]
        }
        else {
            item = SabNZBdService.shared.history[indexPath.row]
        }
        SabNZBdService.shared.deleteItem(item)
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        tableView!.reloadData()
        updateHeader()
    }
    
    func sabNZBdHistoryUpdated() {
        tableView!.reloadData()
    }
    
    // TODO: Add protocol extension with default implementations
    func sabNZBDFullHistoryFetched() { }
    func willRemoveSABItem(_ sabItem: SABItem) { }
    
    // MARK: - SickbeardListener
    
    func sickbeardShowCacheUpdated() {
        tableView?.reloadData()
    }
    
    public func sickbeardShowAdded(_: SickbeardShow) {
        tableView?.reloadData()
    }

}

extension SabNZBdViewController: DownTabBarItem {
    
    var tabIcon: UIImage {
        get {
            return R.image.sabnzbdTabbar()!
        }
    }
    
    var selectedTabBackground: UIColor {
        get {
            return DownApplication.SabNZBd.color
        }
    }
    
    var deselectedTabBackground: UIColor {
        get {
            return DownApplication.SabNZBd.darkColor
        }
    }
}
