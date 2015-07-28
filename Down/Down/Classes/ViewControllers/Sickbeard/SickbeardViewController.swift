//
//  SickbeardViewController.swift
//  Down
//
//  Created by Ruud Puts on 05/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SickbeardViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SickbeardListener {
    
    weak var sickbeardService: SickbeardService!

    convenience init() {
        self.init(nibName: "SickbeardViewController", bundle: nil)
        
        sickbeardService = serviceManager.sickbeardService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moreCellNib = UINib(nibName: "DownMoreCell", bundle:nil)
        tableView.registerNib(moreCellNib, forCellReuseIdentifier: "DownMoreCell")
        
        let loadingCellNib = UINib(nibName: "SABLoadingCell", bundle:nil)
        tableView.registerNib(loadingCellNib, forCellReuseIdentifier: "SABLoadingCell")
        
        let emtpyCellNib = UINib(nibName: "SABEmptyCell", bundle:nil)
        tableView.registerNib(emtpyCellNib, forCellReuseIdentifier: "SABEmptyCell")
        
        let itemCellNib = UINib(nibName: "SickbeardTodayCell", bundle:nil)
        tableView.registerNib(itemCellNib, forCellReuseIdentifier: "SickbeardTodayCell")
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
        
        if section == 0 {
            isEmpty = (sickbeardService.future[SickbeardFutureItem.Category.Today.rawValue] as [SickbeardFutureItem]!).count == 0
        }
        
        return isEmpty
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = tableView.rowHeight
        
        if indexPath.section == 1 {
            height = 153
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let data = sickbeardService.future[SickbeardFutureItem.Category.Today.rawValue] as [SickbeardFutureItem]?
        if indexPath.section == 1 {
            if data == nil {
                let loadingCell = tableView.dequeueReusableCellWithIdentifier("SABLoadingCell", forIndexPath: indexPath) as! SABLoadingCell
                // For some reason this has to be called all the time
                if !loadingCell.activityIndicator.isAnimating() {
                    loadingCell.activityIndicator.startAnimating()
                }
                cell = loadingCell
            }
            else if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
                let emptyCell = tableView.dequeueReusableCellWithIdentifier("SABEmptyCell", forIndexPath: indexPath) as! SABEmptyCell
                emptyCell.label.text = "No shows airing today."
                
                cell = emptyCell
            }
            else {
                let itemCell = tableView.dequeueReusableCellWithIdentifier("SickbeardTodayCell", forIndexPath: indexPath) as! SickbeardTodayCell
                
                let item = (data as [SickbeardFutureItem]!)[indexPath.row]
                itemCell.episodeLabel.text = "\(item.showName) - S\(item.season)E\(item.episode) - \(item.episodeName)"
                itemCell.dateLabel.text = item.airDate
                
                cell = itemCell
            }
            
        }
        else {
            let moreCell = tableView.dequeueReusableCellWithIdentifier("DownMoreCell", forIndexPath: indexPath) as! DownMoreCell
            if indexPath.row == 0 {
                moreCell.label?.text = "All shows"
            }
            else {
                moreCell.label?.text = "History"
            }
            cell = moreCell
        }
    
        return cell
    }
    
    // MARK: - TableView Delegate
    
    // MARK: - SickbeardListener
    
    func sickbeardHistoryUpdated() {
        self.tableView.reloadData()
    }
    
    func sickbeardFutureUpdated() {
        self.tableView.reloadData()
    }
    
}
