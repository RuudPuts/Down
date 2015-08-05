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
    
    convenience init() {
        self.init(nibName: "SabNZBdHistoryViewController", bundle: nil)
        title = "History"
        
        sabNZBdService = serviceManager.sabNZBdService
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
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        sabNZBdService.addListener(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        sabNZBdService.removeListener(self)
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - TableView datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = sabNZBdService.history.count
        if !sabNZBdService.fullHistoryFetched {
            numberOfRows++
        }
        return max(numberOfRows, 1)
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return serviceManager.sabNZBdService.history.count == 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: Float = 60
        if !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if indexPath.row < sabNZBdService.history.count {
                let historyItem: SABHistoryItem = serviceManager.sabNZBdService.history[indexPath.row];
                if (historyItem.hasProgress) {
                    rowHeight = 66.0
                }
            }
        }
        
        return CGFloat(rowHeight)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let sabNZBdService = self.serviceManager.sabNZBdService
        if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if sabNZBdService.lastRefresh != nil {
                let emptyCell = tableView.dequeueReusableCellWithIdentifier("SABEmptyCell", forIndexPath: indexPath) as! SABEmptyCell
                emptyCell.label.text = "Your History is empty."
                cell = emptyCell
            }
            else {
                let loadingCell = tableView.dequeueReusableCellWithIdentifier("SABLoadingCell", forIndexPath: indexPath) as! SABLoadingCell
                // For some reason this has to be called all the time
                if !loadingCell.activityIndicator.isAnimating() {
                    loadingCell.activityIndicator.startAnimating()
                }
                cell = loadingCell
            }
        }
        else if indexPath.row == sabNZBdService.history.count && !sabNZBdService.fullHistoryFetched {
            let loadingCell = tableView.dequeueReusableCellWithIdentifier("SABLoadingCell", forIndexPath: indexPath) as! SABLoadingCell
            // For some reason this has to be called all the time
            loadingCell.activityIndicator.startAnimating()
            cell = loadingCell
        }
        else {
            let itemCell = tableView.dequeueReusableCellWithIdentifier("SABItemCell", forIndexPath: indexPath) as! SABItemCell
            let historyItem: SABHistoryItem = sabNZBdService.history[indexPath.row];
            itemCell.historyItem = historyItem
            
            cell = itemCell
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell is SABLoadingCell && self.tableView.numberOfRowsInSection(indexPath.section) > 0 {
            sabNZBdService.fetchHistory()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let item: SABHistoryItem = sabNZBdService.history[indexPath.row]
        sabNZBdService.deleteItem(item)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = sabNZBdService.history[indexPath.row];
        let detailViewController = SabNZBdDetailViewController(sabItem: item)
        navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        self.tableView.reloadData()
    }
    
    func sabNZBdHistoryUpdated() {
        self.tableView.reloadData()
    }
    
    func sabNZBDFullHistoryFetched() {
        self.tableView.reloadData()
    }
    
}