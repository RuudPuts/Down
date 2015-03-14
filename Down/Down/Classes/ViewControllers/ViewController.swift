//
//  ViewController.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener {
    
    let serviceManager: ServiceManager!

    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        serviceManager = appDelegate.serviceManager
        serviceManager.sabNZBdService.addListener(self)
    }
    
    convenience required init(coder: NSCoder) {
        self.init()
    }
    
    convenience override init() {
        self.init(nibName: "ViewController", bundle: nil)
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
            var queueCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell?
            if queueCell == nil {
                queueCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
            }
            
            let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
            
            queueCell!.textLabel!.text = queueItem.filename
            
            cell = queueCell!
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

