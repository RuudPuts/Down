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

class SabNZBdDetailViewController: DownDetailViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener {
    
    private enum SabNZBdDetailRow {
        case Name
        case Status
        case TotalSize
        
        // Queue specifics
        case Progress
        case Downloaded
        
        // History specifics
        case FinishedAt
        
        // Sickbeard Specifics
        case SickbeardShow
        case SickbeardEpisode
        case SickbeardEpisodeName
    }
    
    weak var sabNZBdService: SabNZBdService!
    
    private weak var sabItem: SABItem!
    private var cellKeys: [[SabNZBdDetailRow]]!
    private var cellTitles: [[String]]!
    
    private var historyItemReplacement: String?
    private var historySwitchRefreshCount = 0
    
    convenience init(sabItem: SABItem) {
        self.init(nibName: "DownDetailViewController", bundle: nil)
        
        self.sabItem = sabItem
        sabNZBdService = serviceManager.sabNZBdService
        
        configureTableView()
        title = "Details"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setTableViewHeaderImage(sabItem.sickbeardEpisode?.show?.banner ?? UIImage(named: "SickbeardDefaultBanner"))
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
    
    func configureTableView() {
        if sabItem is SABQueueItem {
            cellKeys = [[.Name, .Status, .Progress]]
            cellTitles = [["Name", "Status", "Progress"]]
        }
        else {
            cellKeys = [[.Name, .TotalSize, .Status, .FinishedAt]]
            cellTitles = [["Name", "Total size", "Status", "Finished at"]]
        }
        
        if sabItem.sickbeardEpisode != nil {
            cellKeys.append([.SickbeardShow, .SickbeardEpisode, .SickbeardEpisodeName])
            cellTitles.append(["Show", "Episode", "Title"])
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellKeys[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: SABDetailCell
        if sabItem is SABQueueItem {
            cell = self.tableView(tableView, queueCellForRowAtIndexPath: indexPath);
        }
        else {
            cell = self.tableView(tableView, historyCellForRowAtIndexPath: indexPath);
        }
        
        return cell
    }
    
    private func tableView(tableView: UITableView, queueCellForRowAtIndexPath indexPath: NSIndexPath) -> SABDetailCell {
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
            
        case .SickbeardShow:
            detailText = queueItem.sickbeardEpisode!.show?.name
            break;
        case .SickbeardEpisode:
            detailText = "S\(queueItem.sickbeardEpisode!.season?.id)E\(queueItem.sickbeardEpisode!.id)"
            break;
        case .SickbeardEpisodeName:
            detailText = queueItem.sickbeardEpisode!.name
            break;
        default:
            break
        }
        cell.detailTextLabel?.text = detailText
        return cell
    }
    
    private func tableView(tableView: UITableView, historyCellForRowAtIndexPath indexPath: NSIndexPath) -> SABDetailCell {
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
            
        case .SickbeardShow:
            detailText = historyItem.sickbeardEpisode!.show?.name
            break;
        case .SickbeardEpisode:
            detailText = "S\(historyItem.sickbeardEpisode!.season!.id)E\(historyItem.sickbeardEpisode!.id)"
            break;
        case .SickbeardEpisodeName:
            detailText = historyItem.sickbeardEpisode!.name
            break;
        default:
            break
        }
        cell.detailTextLabel?.text = detailText
        
        return cell
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        if sabItem is SABQueueItem {
            tableView.reloadData()
        }
    }
    
    func sabNZBdHistoryUpdated() {
        var shouldReloadTable = sabItem is SABHistoryItem
        if let historyItemIdentifier = historyItemReplacement {
            sabItem = sabNZBdService.findHistoryItem(historyItemIdentifier)
            
            if sabItem != nil {
                historyItemReplacement = nil
                shouldReloadTable = true
                configureTableView()
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Automatic)
            }
            else {
                historySwitchRefreshCount++
                if (historySwitchRefreshCount == 1) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
        
        if shouldReloadTable {
            tableView.reloadData()
        }
    }
    
    func sabNZBDFullHistoryFetched() { }
    
    func willRemoveSABItem(sabItem: SABItem) {
        if sabItem == self.sabItem {
            if sabItem is SABQueueItem {
                historyItemReplacement = sabItem.identifier
            }
            else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
}