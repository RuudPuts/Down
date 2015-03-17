//
//  SabNZBdViewController.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SabNZBdViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedDescriptionLabel: UILabel!
    @IBOutlet weak var timeleftLabel: UILabel!
    @IBOutlet weak var mbRemainingLabel: UILabel!
    
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
    
    func updateHeaderWidgets() {
        var displaySpeed = serviceManager.sabNZBdService.currentSpeed as Float!
        var displayString = "KB/s"
        if (displaySpeed > 1024) {
            displaySpeed = displaySpeed / 1024
            displayString = "MB/s"
            
            if (displaySpeed > 1024) {
                displaySpeed = displaySpeed / 1024
                displayString = "GB/s"
            }
        }
        self.speedLabel!.text = String(format: "%.1f", displaySpeed)
        self.speedDescriptionLabel!.text = displayString
        
        self.timeleftLabel!.text = serviceManager.sabNZBdService.timeRemaining
        
        self.mbRemainingLabel!.text = "\(serviceManager.sabNZBdService.mbLeft!)MB"
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
        var rowHeight: CGFloat! = 56.0
        if indexPath.section == 0 { // TODO: Change to item state check
            let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
            if (queueItem.status == SABQueueItem.SABQueueItemStatus.Downloading) {
                rowHeight = 66.0
            }
        }
        
        return rowHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = (NSBundle.mainBundle().loadNibNamed("SABHeaderView", owner: self, options: nil) as Array).first as SABHeaderView!

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
        self.tableView.reloadData()
        updateHeaderWidgets()
    }
    
    func sabNZBdHistoryUpdated() {
        self.tableView.reloadData()
    }

}
