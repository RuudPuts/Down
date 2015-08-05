//
//  TodayViewController.swift
//  SabQueueWidget
//
//  Created by Ruud Puts on 03/08/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import UIKit
import NotificationCenter

//TODO: Refactor so this and SabViewController use shared datasource code
// Also move shared code into a framework, let's do it right right away :-P
// Cleanup target memberships
class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, SabNZBdListener {
    
    @IBOutlet weak var tableView: UITableView!
    let serviceManager = ServiceManager()
    weak var sabNZBdService: SabNZBdService!
    
    let cellHeight: CGFloat = 60
    let activeCellHeight: CGFloat = 66
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        PreferenceManager.sabNZBdHost = "http://192.168.178.10:8080"
        PreferenceManager.sabNZBdApiKey = "49b77b422da54f699a58562f3a1debaa"
        
        PreferenceManager.sickbeardHost = "http://192.168.178.10:8081"
        PreferenceManager.sickbeardApiKey = "e9c3be0f3315f09d7ceae37f1d3836cd"
        
        PreferenceManager.couchPotatoHost = "http://192.168.178.10:8082"
        PreferenceManager.couchPotatoApiKey = "fb3f91e38ba147b29514d56a24d17d9a"
        
        sabNZBdService = serviceManager.sabNZBdService
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let loadingCellNib = UINib(nibName: "SABLoadingCell", bundle:nil)
        tableView.registerNib(loadingCellNib, forCellReuseIdentifier: "SABLoadingCell")
        
        let emtpyCellNib = UINib(nibName: "SABEmptyCell", bundle:nil)
        tableView.registerNib(emtpyCellNib, forCellReuseIdentifier: "SABEmptyCell")
        
        let itemCellNib = UINib(nibName: "SABItemCell", bundle:nil)
        tableView.registerNib(itemCellNib, forCellReuseIdentifier: "SABItemCell")
        
        sabNZBdService.addListener(self)
        
        updateSize()
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets()
    }
    
    private func updateSize() {
        var requiredHeight: CGFloat = 0
        if self.tableView(tableView, isSectionEmtpy: 0) {
            requiredHeight = cellHeight
        }
        else {
            for item in sabNZBdService.queue {
                if item.hasProgress {
                    requiredHeight += activeCellHeight
                }
                else {
                    requiredHeight += cellHeight
                }
            }
        }
        preferredContentSize = CGSizeMake(CGRectGetWidth(view.frame), requiredHeight);
    }
    
    // MARK: - Widget
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    // MARK: - TableView datasource
    
    func reloadTableView() {
        self.tableView.reloadData();
        preferredContentSize = CGSizeMake(CGRectGetWidth(view.frame),
                                          CGFloat(self.tableView(tableView, numberOfRowsInSection:0) * 66));
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(sabNZBdService.queue.count, 1)
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return serviceManager.sabNZBdService.queue.count == 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: Float = 60
        if !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            let queueItem: SABQueueItem = serviceManager.sabNZBdService.queue[indexPath.row];
            if (queueItem.hasProgress) {
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
                let emptyCell = tableView.dequeueReusableCellWithIdentifier("SABEmptyCell", forIndexPath: indexPath) as! SABEmptyCell
                
                emptyCell.label.text = "Your queue is empty."
                
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
        else {
            let itemCell = tableView.dequeueReusableCellWithIdentifier("SABItemCell", forIndexPath: indexPath) as! SABItemCell
            if indexPath.section == 0 {
                let queueItem: SABQueueItem = sabNZBdService.queue[indexPath.row];
                itemCell.queueItem = queueItem
            }
            else {
                let historyItem: SABHistoryItem = sabNZBdService.history[indexPath.row];
                itemCell.historyItem = historyItem
            }
            cell = itemCell
        }
        
        return cell;
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        updateSize()
        reloadTableView()
    }
    
    func sabNZBdHistoryUpdated() { }
    func sabNZBDFullHistoryFetched() { }
    
}
