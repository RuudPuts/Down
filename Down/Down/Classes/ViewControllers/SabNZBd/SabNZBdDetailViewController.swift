//
//  SabNZBdDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 12/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import XCGLogger
import DownKit

class SabNZBdDetailViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener {
    
    private enum SabNZBdDetailRow {
        case Name
        case Status
        case NZBName
        case NZBProvider
        case TotalSize
        
        // Queue specifics
        case Progress
        case Downloaded
        
        // History specifics
        case FinishedAt
    }
    
    weak var sabNZBdService: SabNZBdService!
    
    private weak var sabItem: SABItem!
    private var cellKeys: [[SabNZBdDetailRow]]!
    private var cellTitles: [[String]]!
    
    convenience init(sabItem: SABItem) {
        self.init(nibName: "SabNZBdDetailViewController", bundle: nil)
        
        self.sabItem = sabItem
        sabNZBdService = serviceManager.sabNZBdService
        
        if sabItem is SABQueueItem {
            cellKeys = [[.Name, .Status, .Progress], [.NZBName, .NZBProvider]]
            cellTitles = [["Name", "Status", "Progress"], ["NZB", "NZB Provider"]]
        }
        else {
            cellKeys = [[.Name, .TotalSize, .Status, .FinishedAt], [.NZBName, .NZBProvider]]
            cellTitles = [["Name", "Total size", "Status", "Finished at"], ["NZB", "NZB Provider"]]
            
        }
        title = "Details"
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
        print("Detail: \(ObjectIdentifier(sabItem).uintValue)")
        return cellKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellKeys[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if sabItem is SABQueueItem {
            return self.tableView(tableView, queueCellForRowAtIndexPath: indexPath);
        }
        else {
            return self.tableView(tableView, historyCellForRowAtIndexPath: indexPath);
        }
    }
    
    private func tableView(tableView: UITableView, queueCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "queueCell"
        let cell = SABDetailCell(style: .Value2, reuseIdentifier: reuseIdentifier)
        let queueItem = sabItem as! SABQueueItem
        
        cell.textLabel?.text = cellTitles[indexPath.section][indexPath.row]
        var detailText: String?
        
        switch cellKeys[indexPath.section][indexPath.row] {
        case .Name:
            detailText = queueItem.displayName
            break
        case .Status:
            detailText = queueItem.statusDescription
            cell.detailTextLabel?.textColor = .whiteColor()
            break
        case .Progress:
            detailText = queueItem.progressString
            break
        case .NZBName:
            detailText = queueItem.nzbName
            break
        default:
            break
        }
        cell.detailTextLabel?.text = detailText
        return cell
    }
    
    private func tableView(tableView: UITableView, historyCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "historyCell"
        let cell = SABDetailCell(style: .Value2, reuseIdentifier: reuseIdentifier)
        let historyItem = sabItem as! SABHistoryItem
        
        cell.textLabel?.text = cellTitles[indexPath.section][indexPath.row]
        var detailText: String?
        
        switch cellKeys[indexPath.section][indexPath.row] {
        case .Name:
            detailText = historyItem.displayName
            break
        case .Status:
            detailText = historyItem.statusDescription
            switch (historyItem.status!) {
            case .Finished:
                cell.detailTextLabel?.textColor = .downGreenColor()
            case .Failed:
                cell.detailTextLabel?.textColor = .downRedColor()
            default:
                cell.detailTextLabel?.textColor = .whiteColor()
            }
            break
        case .TotalSize:
            detailText = historyItem.size
            break
        case .FinishedAt:
            detailText = NSDateFormatter.defaultFormatter().stringFromDate(historyItem.completionDate!)
            break
        case .NZBName:
            detailText = historyItem.nzbName
            break
        default:
            break
        }
        cell.detailTextLabel?.text = detailText
        
        return cell
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        tableView.reloadData()
    }
    
    func sabNZBdHistoryUpdated() {
        tableView.reloadData()
    }
    
    func sabNZBDFullHistoryFetched() { }
    
}