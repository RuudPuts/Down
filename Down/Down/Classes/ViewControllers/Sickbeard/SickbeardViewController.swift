//
//  SickbeardViewController.swift
//  Down
//
//  Created by Ruud Puts on 05/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SickbeardViewController: DownViewController, UITableViewDataSource, UITableViewDelegate, SickbeardListener {
    
    weak var sickbeardService: SickbeardService!
    var todayData: [SickbeardEpisode]?
    var soonData: [SickbeardEpisode]?

    convenience init() {
        self.init(nibName: "SickbeardViewController", bundle: nil)
        
        sickbeardService = serviceManager.sickbeardService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moreCellNib = UINib(nibName: "DownIconTextCell", bundle:nil)
        tableView.registerNib(moreCellNib, forCellReuseIdentifier: "DownIconTextCell")
        
        let loadingCellNib = UINib(nibName: "DownLoadingCell", bundle:nil)
        tableView.registerNib(loadingCellNib, forCellReuseIdentifier: "DownLoadingCell")
        
        let emtpyCellNib = UINib(nibName: "DownEmptyCell", bundle:nil)
        tableView.registerNib(emtpyCellNib, forCellReuseIdentifier: "DownEmptyCell")
        
        let itemCellNib = UINib(nibName: "SickbeardTodayCell", bundle:nil)
        tableView.registerNib(itemCellNib, forCellReuseIdentifier: "SickbeardTodayCell")
        
        reloadTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sickbeardService.addListener(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        sickbeardService.removeListener(self)
    }
    
    // MARK: - TableView DataSource
    
    private func reloadTableView() {
        if let future = sickbeardService.future {
            todayData = future[SickbeardService.SickbeardFutureCategory.Today.rawValue] as [SickbeardEpisode]!
            soonData = future[SickbeardService.SickbeardFutureCategory.Soon.rawValue] as [SickbeardEpisode]!
        }
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections = 2
        if soonData != nil {
            sections = 3
        }
        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 2
        
        if section == 1 {
            rows = todayData?.count ?? 1
        }
        else if section == 2 {
            rows = soonData?.count ?? 1
        }
        
        return rows
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        var isEmpty = false
        
        if section == 1 {
            isEmpty = true
            if let data = todayData {
                isEmpty = data.count == 0
            }
        }
        else if section == 2 {
            isEmpty = true
            if let data = soonData {
                isEmpty = data.count == 0
            }
        }
    
        return isEmpty
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = tableView.rowHeight
        
        if indexPath.section > 0 && !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            // Width of screen, in 758x140 ratio. 60 extra for labels
            height = (CGRectGetWidth(view.bounds) / 758 * 140) + 60
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section > 0 {
            var data = todayData
            if indexPath.section == 2 {
                data = soonData
            }
            
            if data == nil {
                let loadingCell = tableView.dequeueReusableCellWithIdentifier("DownLoadingCell", forIndexPath: indexPath) as! DownLoadingCell
                loadingCell.activityIndicator.color = .downSickbeardColor()
                cell = loadingCell
            }
            else if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
                let emptyCell = tableView.dequeueReusableCellWithIdentifier("DownEmptyCell", forIndexPath: indexPath) as! DownEmptyCell
                emptyCell.label.text = "No shows airing today."
                
                cell = emptyCell
            }
            else {
                let itemCell = tableView.dequeueReusableCellWithIdentifier("SickbeardTodayCell", forIndexPath: indexPath) as! SickbeardTodayCell
                
                let episode = data![indexPath.row]
                itemCell.episodeLabel.text = episode.displayName
                itemCell.dateLabel.text = episode.airDate
                itemCell.bannerView?.image = episode.show?.banner
                
                cell = itemCell
            }
            
        }
        else {
            let iconTextCell = tableView.dequeueReusableCellWithIdentifier("DownIconTextCell", forIndexPath: indexPath) as! DownIconTextCell
            iconTextCell.setCellType(.Sickbeard)
            if indexPath.row == 0 {
                iconTextCell.label?.text = "All shows"
                iconTextCell.iconView?.image = UIImage(named: "sickbeard-allshows")
            }
            else {
                iconTextCell.label?.text = "History"
                iconTextCell.iconView?.image = UIImage(named: "sickbeard-history")
            }
            cell = iconTextCell
        }
    
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView? = nil
        
        if section > 0 {
            let header = (NSBundle.mainBundle().loadNibNamed("SickbeardHeaderView", owner: self, options: nil) as Array).first as! SickbeardHeaderView
            header.textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
            header.imageView.image = self.tableView(tableView, iconForHeaderInSection: section)
            let detailText = section == 1 ? "\(NSCalendar.currentCalendar().components(.Day, fromDate: NSDate()).day)" : "?"
            header.detailLabel.text = detailText
            
            headerView = header
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle: String?
        
        switch section {
        case 1:
            sectionTitle = "Airing today"
            break
        case 2:
            sectionTitle = "Airing soon"
            break
        default:
            break
        }
        
        return sectionTitle
    }
    
    func tableView(tableView: UITableView, iconForHeaderInSection section: Int) -> UIImage? {
        return UIImage(named: "sickbeard-airingtoday")
    }
    
    // MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.isEqual(NSIndexPath(forRow: 0, inSection: 0)) {
            let showsViewController = SickbeardShowsViewController()
            navigationController?.pushViewController(showsViewController, animated: true)
        }
    }
    
    // MARK: - SickbeardListener
    
    func sickbeardHistoryUpdated() { }
    
    func sickbeardFutureUpdated() {
        self.tableView.reloadData()
    }
    
}
