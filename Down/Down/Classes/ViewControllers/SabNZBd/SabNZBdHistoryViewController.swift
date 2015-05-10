//
//  SabNZBdHistoryViewController.swift
//  Down
//
//  Created by Ruud Puts on 10/05/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

class SabNZBdHistoryViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener {
    
    weak var sabNZBdService: SabNZBdService!
    
    var finishedLoading = false
    
    convenience init() {
        self.init(nibName: "SabNZBdHistoryViewController", bundle: nil)
        
        self.sabNZBdService = serviceManager.sabNZBdService
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
        
        self.sabNZBdService.addListener(self)
    }
    
    // MARK: - TableView datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = self.sabNZBdService.history.count
        if !self.finishedLoading {
            numberOfRows++
        }
        return max(sabNZBdService.history.count, 1)
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return serviceManager.sabNZBdService.history.count == 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: Float = 60
        if !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            let historyItem: SABHistoryItem = serviceManager.sabNZBdService.history[indexPath.row];
            if (historyItem.hasProgress!) {
                rowHeight = 66.0
            }
        }
        
        return CGFloat(rowHeight)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let sabNZBdService = self.serviceManager.sabNZBdService
        if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if sabNZBdService.lastRefresh != nil {
                var emptyCell = tableView.dequeueReusableCellWithIdentifier("SABEmptyCell", forIndexPath: indexPath) as! SABEmptyCell
                emptyCell.label.text = "Your History is empty."
                cell = emptyCell
            }
            else {
                var loadingCell = tableView.dequeueReusableCellWithIdentifier("SABLoadingCell", forIndexPath: indexPath) as! SABLoadingCell
                // For some reason this has to be called all the time
                loadingCell.activityIndicator.startAnimating()
                cell = loadingCell
            }
        }
        else if indexPath.row == self.sabNZBdService.history.count && !self.finishedLoading {
            var loadingCell = tableView.dequeueReusableCellWithIdentifier("SABLoadingCell", forIndexPath: indexPath) as! SABLoadingCell
            // For some reason this has to be called all the time
            loadingCell.activityIndicator.startAnimating()
            cell = loadingCell
        }
        else {
            var itemCell = tableView.dequeueReusableCellWithIdentifier("SABItemCell", forIndexPath: indexPath) as! SABItemCell
            let historyItem: SABHistoryItem = sabNZBdService.history[indexPath.row];
            itemCell.historyItem = historyItem
            
            cell = itemCell
        }
        
        return cell;
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        self.tableView.reloadData()
    }
    
    func sabNZBdHistoryUpdated() {
        self.tableView.reloadData()
    }
    
}