//
//  SickbeardEpisodeViewController.swift
//  Down
//
//  Created by Ruud Puts on 12/19/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import DownKit

class SickbeardEpisodeViewController: DownDetailViewController, UITableViewDataSource, UITableViewDelegate {
    
    private enum EpisodeDetailRowType {
        case Name
        case AirDate
        case Show
        case Season
        case Episode
        case Status
        
        case Plot
    }
    
    private struct EpisodeDetailDataSource {
        var rowType: EpisodeDetailRowType
        var title: String
    }
    
    var episode: SickbeardEpisode? {
        didSet {
            configureTableView()
        }
    }
    private var tableData = [[EpisodeDetailDataSource]]()
    
    private var historyItemReplacement: String?
    private var historySwitchRefreshCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let plotCellNib = UINib(nibName: "DownTextCell", bundle: NSBundle.mainBundle())
        tableView!.registerNib(plotCellNib, forCellReuseIdentifier: "DownTextCell")
        
        setTableViewHeaderImage(episode?.show?.banner ?? UIImage(named: "SickbeardDefaultBanner"))
    }
    
    // MARK: - TableView datasource
    
    func configureTableView() {
        tableData.removeAll()
        
        // Section 0
        var section0 = [EpisodeDetailDataSource]()
        section0.append(EpisodeDetailDataSource(rowType: .Name, title: "Name"))
        section0.append(EpisodeDetailDataSource(rowType: .AirDate, title: "Aired on"))
        section0.append(EpisodeDetailDataSource(rowType: .Show, title: "Show"))
        section0.append(EpisodeDetailDataSource(rowType: .Season, title: "Season"))
        section0.append(EpisodeDetailDataSource(rowType: .Episode, title: "Episode"))
        section0.append(EpisodeDetailDataSource(rowType: .Status, title: "Status"))
        tableData.append(section0)
        
        if episode?.plot.length > 0 {
            // Section 1
            var section1 = [EpisodeDetailDataSource]()
            section1.append(EpisodeDetailDataSource(rowType: .Plot, title: ""))
            tableData.append(section1)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableData[indexPath.section][indexPath.row].rowType == .Plot {
            let font = UIFont(name: "OpenSans-Light", size: 14.0)!
            let maxWidth = CGRectGetWidth(view.bounds) - 34 // TODO: Change to 20 once sizing issue is fixed
            
            return episode!.plot.sizeWithFont(font, width:maxWidth).height + 30
        }
        
        return tableView.rowHeight;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            let reuseIdentifier = "episodeCell"
            cell = DownTableViewCell(style: .Value2, reuseIdentifier: reuseIdentifier)
            let cellData = tableData[indexPath.section][indexPath.row]
            
            cell.textLabel?.text = cellData.title
            var detailText: String?
            
            switch cellData.rowType {
            case .Name:
                detailText = episode?.name
                break
            case .AirDate:
                if let date = episode?.airDate {
                    detailText = NSDateFormatter.downDateFormatter().stringFromDate(date)
                }
                else {
                    detailText = "-"
                }
                break
            case .Show:
                detailText = episode?.show?.name ?? "-"
                break
            case .Season:
                detailText = episode?.season == nil ? "-" : String(episode?.season!.id)
                break
            case .Episode:
                detailText = String(episode?.id)
                break
            case .Status:
                detailText = episode?.status
                break
                
            default:
                detailText = ""
                break
            }
            cell.detailTextLabel?.text = detailText
        }
        else {
            let plotCell = tableView.dequeueReusableCellWithIdentifier("DownTextCell") as! DownTextCell
            plotCell.cheveronHidden = true
            plotCell.label.text = episode?.plot
            
            cell = plotCell
        }
        return cell
    }
    
}