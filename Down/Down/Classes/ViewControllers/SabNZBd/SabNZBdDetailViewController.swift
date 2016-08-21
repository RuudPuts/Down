//
//  SabNZBdDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 12/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
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
        case SickbeardAirDate
    }
    
    private struct SabNZBdDetailDataSource {
        var rowType: SabNZBdDetailRow
        var title: String
    }
    
    private var tableData = [[SabNZBdDetailDataSource]]()
    
    private var historyItemReplacement: String?
    private var historySwitchRefreshCount = 0
    
    var sabItem: SABItem? {
        didSet {
            configureTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        if let showBanner = sabItem?.sickbeardEpisode?.show?.banner {
            setTableViewHeaderImage(showBanner)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sabNZBdService.addListener(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
            
        sabNZBdService.removeListener(self)
    }
    
    // MARK: - TableView datasource
    
    func configureTableView() {
        tableData.removeAll()
        
        if sabItem?.sickbeardEpisode != nil {
            var section = [SabNZBdDetailDataSource]()
            section.append(SabNZBdDetailDataSource(rowType: .SickbeardShow, title: "Show"))
            section.append(SabNZBdDetailDataSource(rowType: .SickbeardEpisode, title: "Episode"))
            section.append(SabNZBdDetailDataSource(rowType: .SickbeardEpisodeName, title: "Title"))
            section.append(SabNZBdDetailDataSource(rowType: .SickbeardAirDate, title: "Aired on"))
            
            tableData.append(section)
        }
        
        var detailSection = [SabNZBdDetailDataSource]()
        if sabItem?.sickbeardEpisode == nil {
            detailSection.append(SabNZBdDetailDataSource(rowType: .Name, title: "Name"))
        }
        
        if sabItem is SABQueueItem {
            detailSection.append(SabNZBdDetailDataSource(rowType: .Status, title: "Status"))
            detailSection.append(SabNZBdDetailDataSource(rowType: .Progress, title: "Progress"))
        }
        else {
            detailSection.append(SabNZBdDetailDataSource(rowType: .Status, title: "Status"))
            detailSection.append(SabNZBdDetailDataSource(rowType: .TotalSize, title: "Total size"))
            detailSection.append(SabNZBdDetailDataSource(rowType: .FinishedAt, title: "Finished at"))
        }
        tableData.append(detailSection)
        
        if sabItem?.sickbeardEpisode?.plot.length > 0 {
            var section = [SabNZBdDetailDataSource]()
            
            tableData.append(section)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: DownTableViewCell
        if sabItem is SABQueueItem {
            cell = self.tableView(tableView, queueCellForRowAtIndexPath: indexPath);
        }
        else {
            cell = self.tableView(tableView, historyCellForRowAtIndexPath: indexPath);
        }
        
        return cell
    }
    
    private func tableView(tableView: UITableView, queueCellForRowAtIndexPath indexPath: NSIndexPath) -> DownTableViewCell {
        let reuseIdentifier = "queueCell"
        let cell = DownTableViewCell(style: .Value2, reuseIdentifier: reuseIdentifier)
        let queueItem = sabItem as! SABQueueItem
        let dataSource = tableData[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = dataSource.title
        var detailText: String?
        
        switch dataSource.rowType {
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
            detailText = "S\(queueItem.sickbeardEpisode!.season!.id)E\(queueItem.sickbeardEpisode!.id)"
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
    
    private func tableView(tableView: UITableView, historyCellForRowAtIndexPath indexPath: NSIndexPath) -> DownTableViewCell {
        let reuseIdentifier = "historyCell"
        let cell = DownTableViewCell(style: .Value2, reuseIdentifier: reuseIdentifier)
        let historyItem = sabItem as! SABHistoryItem
        let dataSource = tableData[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = dataSource.title
        var detailText: String?
        
        switch dataSource.rowType {
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
            detailText = NSDateFormatter.downDateTimeFormatter().stringFromDate(historyItem.completionDate!)
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
        case .SickbeardAirDate:
            if let date = historyItem.sickbeardEpisode!.airDate {
                detailText = NSDateFormatter.downDateTimeFormatter().stringFromDate(date)
            }
            else {
                detailText = "-"
            }
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
            tableView!.reloadData()
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
                tableView!.insertRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Automatic)
            }
            else {
                historySwitchRefreshCount += 1
                if historySwitchRefreshCount == 1 {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
        
        if shouldReloadTable {
            tableView!.reloadData()
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