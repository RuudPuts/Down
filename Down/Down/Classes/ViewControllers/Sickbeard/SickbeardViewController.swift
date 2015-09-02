//
//  SickbeardViewController.swift
//  Down
//
//  Created by Ruud Puts on 05/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SickbeardViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SickbeardListener {
    
    @IBOutlet weak var airingTodayLabel: UILabel!
    
    weak var sickbeardService: SickbeardService!

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
        
        updateHeaderWidgets()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sickbeardService.addListener(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        sickbeardService.removeListener(self)
    }
    
    // MARK: - Header widgets
    
    private func updateHeaderWidgets() {
        self.airingTodayLabel.text = "\(self.tableView(tableView, numberOfRowsInSection: 1))"
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 2
        
        if section == 1 {
            let data = sickbeardService.future[SickbeardFutureItem.Category.Today.rawValue] as [SickbeardFutureItem]?
            
            if let futureData = data {
                rows = max(1, futureData.count)
            }
        }
        
        return rows
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        var isEmpty = false
        
        if section == 1 {
            isEmpty = (sickbeardService.future[SickbeardFutureItem.Category.Today.rawValue] as [SickbeardFutureItem]!).count == 0
        }
        
        return isEmpty
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = tableView.rowHeight
        
        if indexPath.section == 1 && !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            // Width of screen, in 758x140 ratio. 60 extra for labels
            height = (CGRectGetWidth(view.bounds) / 758 * 140) + 60
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let data = sickbeardService.future[SickbeardFutureItem.Category.Today.rawValue] as [SickbeardFutureItem]?
        if indexPath.section == 1 {
            if data == nil {
                let loadingCell = tableView.dequeueReusableCellWithIdentifier("DownLoadingCell", forIndexPath: indexPath) as! DownLoadingCell
                // For some reason this has to be called all the time
                if !loadingCell.activityIndicator.isAnimating() {
                    loadingCell.activityIndicator.startAnimating()
                }
                cell = loadingCell
            }
            else if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
                let emptyCell = tableView.dequeueReusableCellWithIdentifier("DownEmptyCell", forIndexPath: indexPath) as! DownEmptyCell
                emptyCell.label.text = "No shows airing today."
                
                cell = emptyCell
            }
            else {
                let itemCell = tableView.dequeueReusableCellWithIdentifier("SickbeardTodayCell", forIndexPath: indexPath) as! SickbeardTodayCell
                
                let item = (data as [SickbeardFutureItem]!)[indexPath.row]
                itemCell.episodeLabel.text = "\(item.showName) - S\(item.season)E\(item.episode) - \(item.episodeName)"
                itemCell.dateLabel.text = item.airDate
                itemCell.bannerView?.image = item.banner
                
                cell = itemCell
            }
            
        }
        else {
            let iconTextCell = tableView.dequeueReusableCellWithIdentifier("DownIconTextCell", forIndexPath: indexPath) as! DownIconTextCell
            iconTextCell.setCheveronType(.Sickbeard)
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
        
        if section == 1 {
            let header = (NSBundle.mainBundle().loadNibNamed("SickbeardHeaderView", owner: self, options: nil) as Array).first as! SickbeardHeaderView
            header.textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
            
            headerView = header
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle: String?
        
        if section == 1 {
            sectionTitle = "Airing today"
        }
        
        return sectionTitle
    }
    
    // MARK: - TableView Delegate
    
    // MARK: - SickbeardListener
    
    func sickbeardHistoryUpdated() {
        self.tableView.reloadData()
        updateHeaderWidgets()
    }
    
    func sickbeardFutureUpdated() {
        self.tableView.reloadData()
        updateHeaderWidgets()
    }
    
}
