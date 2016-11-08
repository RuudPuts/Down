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
    
    fileprivate enum SabNZBdDetailRow {
        case name
        case status
        case totalSize
        
        // Queue specifics
        case progress
        case downloaded
        
        // History specifics
        case finishedAt
        
        // Sickbeard Specifics
        case sickbeardShow
        case sickbeardEpisode
        case sickbeardEpisodeName
        case sickbeardAirDate
        case sickbeardPlot
    }
    
    fileprivate struct SabNZBdDetailDataSource {
        var rowType: SabNZBdDetailRow
        var title: String
    }
    
    fileprivate var tableData = [[SabNZBdDetailDataSource]]()
    
    fileprivate var historyItemReplacement: String?
    fileprivate var historySwitchRefreshCount = 0
    
    var sabItem: SABItem? {
        didSet {
            configureTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let plotCellNib = UINib(nibName: "DownTextCell", bundle: Bundle.main)
        tableView!.register(plotCellNib, forCellReuseIdentifier: "DownTextCell")
        
        guard let episode = sabItem?.sickbeardEpisode else {
            return
        }
        
        if let showBanner = episode.show?.banner {
            setTableViewHeaderImage(showBanner)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SabNZBdService.shared.addListener(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SabNZBdService.shared.removeListener(self)
    }
    
    override func headerImageTapped() {
        super.headerImageTapped()
        
        if let show = sabItem?.sickbeardEpisode?.show {
            showDetailsForShow(show)
        }
    }
    
    // MARK: - TableView datasource
    
    func configureTableView() {
        tableData.removeAll()
        
        if (sabItem?.sickbeardEpisode) != nil {
            var section = [SabNZBdDetailDataSource]()
            section.append(SabNZBdDetailDataSource(rowType: .sickbeardShow, title: "Show"))
            section.append(SabNZBdDetailDataSource(rowType: .sickbeardEpisode, title: "Episode"))
            section.append(SabNZBdDetailDataSource(rowType: .sickbeardEpisodeName, title: "Title"))
            section.append(SabNZBdDetailDataSource(rowType: .sickbeardAirDate, title: "Aired on"))
            
            tableData.append(section)
        }
        
        var detailSection = [SabNZBdDetailDataSource]()
        if sabItem?.sickbeardEpisode == nil {
            detailSection.append(SabNZBdDetailDataSource(rowType: .name, title: "Name"))
        }
        
        if sabItem is SABQueueItem {
            detailSection.append(SabNZBdDetailDataSource(rowType: .status, title: "Status"))
            detailSection.append(SabNZBdDetailDataSource(rowType: .progress, title: "Progress"))
        }
        else {
            detailSection.append(SabNZBdDetailDataSource(rowType: .status, title: "Status"))
            detailSection.append(SabNZBdDetailDataSource(rowType: .totalSize, title: "Total size"))
            detailSection.append(SabNZBdDetailDataSource(rowType: .finishedAt, title: "Finished at"))
        }
        tableData.append(detailSection)
        
        if let episode = sabItem?.sickbeardEpisode, episode.plot.length > 0 {
            var section = [SabNZBdDetailDataSource]()
            section.append(SabNZBdDetailDataSource(rowType: .sickbeardPlot, title: ""))
            
            tableData.append(section)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].rowType == .sickbeardPlot {
            let font = UIFont(name: "OpenSans-Light", size: 14.0)!
            let maxWidth = view.bounds.width - 34 // TODO: Change to 20 once sizing issue is fixed
            
            return sabItem!.sickbeardEpisode!.plot.sizeWithFont(font, width:maxWidth).height + 30
        }
        
        return tableView.rowHeight;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: DownTableViewCell
        let rowData = tableData[indexPath.section][indexPath.row]
        
        if rowData.rowType == .sickbeardPlot {
            let plotCell = tableView.dequeueReusableCell(withIdentifier: "DownTextCell") as! DownTextCell
            plotCell.label.text = sabItem!.sickbeardEpisode!.plot
            plotCell.cheveronHidden = true
            
            cell = plotCell
        }
        else {
            // TODO, some generic filler upper? 
            // And a queue/history specific thingy for quuee/history
            if sabItem is SABQueueItem {
                cell = self.tableView(tableView, queueCellForRowAtIndexPath: indexPath);
            }
            else {
                cell = self.tableView(tableView, historyCellForRowAtIndexPath: indexPath);
            }
        }
        
        return cell
    }
    
    fileprivate func tableView(_ tableView: UITableView, queueCellForRowAtIndexPath indexPath: IndexPath) -> DownTableViewCell {
        let reuseIdentifier = "queueCell"
        let cell = DownTableViewCell(style: .value2, reuseIdentifier: reuseIdentifier)
        let queueItem = sabItem as! SABQueueItem
        let cellData = tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = cellData.title
        var detailText: String?
        
        switch cellData.rowType {
        case .name:
            detailText = queueItem.displayName
            break
        case .status:
            detailText = queueItem.statusDescription
            cell.detailTextLabel?.textColor = .white
            break
        case .progress:
            detailText = queueItem.progressString
            break
            
        case .sickbeardShow:
            detailText = queueItem.sickbeardEpisode!.show?.name
            break;
        case .sickbeardEpisode:
            detailText = "S\(queueItem.sickbeardEpisode!.season!.id)E\(queueItem.sickbeardEpisode!.id)"
            break;
        case .sickbeardEpisodeName:
            detailText = queueItem.sickbeardEpisode!.name
            break;
        default:
            break
        }
        cell.detailTextLabel?.text = detailText
        return cell
    }
    
    fileprivate func tableView(_ tableView: UITableView, historyCellForRowAtIndexPath indexPath: IndexPath) -> DownTableViewCell {
        let reuseIdentifier = "historyCell"
        let cell = DownTableViewCell(style: .value2, reuseIdentifier: reuseIdentifier)
        let historyItem = sabItem as! SABHistoryItem
        let cellData = tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = cellData.title
        var detailText: String?
        
        switch cellData.rowType {
        case .name:
            detailText = historyItem.displayName
            break
        case .status:
            detailText = historyItem.statusDescription
            switch (historyItem.status!) {
            case .finished:
                cell.detailTextLabel?.textColor = .downGreenColor()
            case .failed:
                cell.detailTextLabel?.textColor = .downRedColor()
            default:
                cell.detailTextLabel?.textColor = .white
            }
            break
        case .totalSize:
            detailText = historyItem.size
            break
        case .finishedAt:
            detailText = historyItem.completionDate!.dateString
            break
            
        case .sickbeardShow:
            detailText = historyItem.sickbeardEpisode!.show?.name
            break;
        case .sickbeardEpisode:
            detailText = "S\(historyItem.sickbeardEpisode!.season!.id)E\(historyItem.sickbeardEpisode!.id)"
            break;
        case .sickbeardEpisodeName:
            detailText = historyItem.sickbeardEpisode!.name
            break;
        case .sickbeardAirDate:
            if let date = historyItem.sickbeardEpisode!.airDate {
                detailText = date.dateString
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
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        if cellData.rowType == .sickbeardShow {
            showDetailsForShow(sabItem!.sickbeardEpisode!.show!)
        }
    }
    
    func showDetailsForShow(_ show: SickbeardShow) {
        let sickbeardStoryboard = UIStoryboard(name: "Sickbeard", bundle: Bundle.main)
        let showDetailViewcontroller = sickbeardStoryboard.instantiateViewController(withIdentifier: "SickbeardShowDetail") as! SickbeardShowViewController
        showDetailViewcontroller.show = show
            
        navigationController?.pushViewController(showDetailViewcontroller, animated: true)
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
            sabItem = SabNZBdService.shared.findHistoryItem(historyItemIdentifier)
            
            if sabItem != nil {
                historyItemReplacement = nil
                shouldReloadTable = true
                configureTableView()
                tableView!.insertRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
            }
            else {
                historySwitchRefreshCount += 1
                if historySwitchRefreshCount == 1 {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        if shouldReloadTable {
            tableView!.reloadData()
        }
    }
    
    func sabNZBDFullHistoryFetched() { }
    
    func willRemoveSABItem(_ sabItem: SABItem) {
        if sabItem == self.sabItem {
            if sabItem is SABQueueItem {
                historyItemReplacement = sabItem.identifier
            }
            else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
