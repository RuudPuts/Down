//
//  SabNZBdViewController.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SabNZBdViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener {
    
    convenience init() {
        self.init(nibName: "SabNZBdViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queueCellNib = UINib(nibName: "SABItemCell", bundle:nil)
        tableView.registerNib(queueCellNib, forCellReuseIdentifier: "SABItemCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        serviceManager.sabNZBdService.addListener(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        serviceManager.sabNZBdService.removeListener(self)
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
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: CGFloat!
        if indexPath.section == 0 { // TODO: Change to item state check
            let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
            if (queueItem.status == SABQueueItem.SABQueueItemStatus.Downloading) {
                rowHeight = 66
            }
        }
        else {
            rowHeight = 56
        }
        
        return rowHeight
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
        let CellIdentifier: String = "SABItemCell"
        var cell: SABItemCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as SABItemCell
        
        if (indexPath.section == 0) {
            let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
            cell.setQueueItem(queueItem)
        }
        else {
            let historyItem: SABHistoryItem = serviceManager.sabNZBdService.history[indexPath.row];
            cell.setHistoryItem(historyItem);
        }
        
        return cell;
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        println("QueueUpdated: \(serviceManager.sabNZBdService.queue.count)")
        self.tableView.reloadData()
    }
    
    func sabNZBdHistoryUpdated() {
        println("HistoryUpdated: \(serviceManager.sabNZBdService.history.count)")
        self.tableView.reloadData()
    }

}
