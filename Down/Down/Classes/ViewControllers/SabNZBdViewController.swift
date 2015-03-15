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
        
        let queueCellNib = UINib(nibName: "SABQueueItemCell", bundle:nil)
        tableView.registerNib(queueCellNib, forCellReuseIdentifier: "SABQueueItemCell")
        
        tableView.rowHeight = 70
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
        var cell: UITableViewCell;
        if (indexPath.section == 0) {
            let CellIdentifier: String = "SABQueueItemCell"
            var queueCell: SABQueueItemCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as SABQueueItemCell
            
            let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
            queueCell.setQueueItem(queueItem)
            cell = queueCell
        }
        else {
            let CellIdentifier: String = "SABHistoryItemCell"
            var queueCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell?
            if queueCell == nil {
                queueCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
            }
            
            let queueItem: SABHistoryItem = serviceManager.sabNZBdService.history[indexPath.row];
            
            queueCell!.textLabel!.text = queueItem.filename
            
            cell = queueCell!
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
