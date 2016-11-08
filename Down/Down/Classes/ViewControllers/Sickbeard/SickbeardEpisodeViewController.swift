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
    
    fileprivate enum EpisodeDetailRowType {
        case name
        case airDate
        case show
        case season
        case episode
        case status
        
        case plot
    }
    
    fileprivate struct EpisodeDetailDataSource {
        var rowType: EpisodeDetailRowType
        var title: String
    }
    
    var episode: SickbeardEpisode? {
        didSet {
            configureTableView()
        }
    }
    fileprivate var tableData = [[EpisodeDetailDataSource]]()
    
    fileprivate var historyItemReplacement: String?
    fileprivate var historySwitchRefreshCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let plotCellNib = UINib(nibName: "DownTextCell", bundle: Bundle.main)
        tableView!.register(plotCellNib, forCellReuseIdentifier: "DownTextCell")
        
        setTableViewHeaderImage(episode?.show?.banner ?? UIImage(named: "SickbeardDefaultBanner"))
    }
    
    override func headerImageTapped() {
        performSegue(withIdentifier: "SickbeardShow", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let show = episode?.show , segue.identifier == "SickbeardShow" {
            let showViewController = segue.destination as! SickbeardShowViewController
            showViewController.show = show
        }
    }
    
    // MARK: - TableView datasource
    
    func configureTableView() {
        tableData.removeAll()
        
        guard episode != nil else {
            return
        }
        
        // Section 0
        var section0 = [EpisodeDetailDataSource]()
        section0.append(EpisodeDetailDataSource(rowType: .name, title: "Name"))
        section0.append(EpisodeDetailDataSource(rowType: .airDate, title: "Aired on"))
        section0.append(EpisodeDetailDataSource(rowType: .show, title: "Show"))
        section0.append(EpisodeDetailDataSource(rowType: .season, title: "Season"))
        section0.append(EpisodeDetailDataSource(rowType: .episode, title: "Episode"))
        section0.append(EpisodeDetailDataSource(rowType: .status, title: "Status"))
        tableData.append(section0)
        
        if episode!.plot.length > 0 {
            // Section 1
            var section1 = [EpisodeDetailDataSource]()
            section1.append(EpisodeDetailDataSource(rowType: .plot, title: ""))
            tableData.append(section1)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].rowType == .plot {
            let font = UIFont(name: "OpenSans-Light", size: 14.0)!
            let maxWidth = view.bounds.width - 34 // TODO: Change to 20 once sizing issue is fixed
            
            return episode!.plot.sizeWithFont(font, width:maxWidth).height + 30
        }
        
        return tableView.rowHeight;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DownTableViewCell
        
        if indexPath.section == 0 {
            let reuseIdentifier = "episodeCell"
            cell = DownTableViewCell(style: .value2, reuseIdentifier: reuseIdentifier)
            let cellData = tableData[indexPath.section][indexPath.row]
            
            cell.textLabel?.text = cellData.title
            var detailText: String?
            
            switch cellData.rowType {
            case .name:
                detailText = episode!.name
                break
            case .airDate:
                if let date = episode!.airDate {
                    detailText = date.dateString
                }
                else {
                    detailText = "-"
                }
                break
            case .show:
                detailText = episode!.show?.name ?? "-"
                break
            case .season:
                detailText = episode!.season == nil ? "-" : String(episode!.season!.id)
                break
            case .episode:
                detailText = String(episode!.id)
                break
            case .status:
                detailText = episode!.status.rawValue
                break
                
            default:
                detailText = ""
                break
            }
            cell.detailTextLabel?.text = detailText
        }
        else {
            let plotCell = tableView.dequeueReusableCell(withIdentifier: "DownTextCell") as! DownTextCell
            plotCell.label.text = episode!.plot
            plotCell.cheveronHidden = true
            
            cell = plotCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        if cellData.rowType == .show {
            performSegue(withIdentifier: "SickbeardShow", sender: nil)
        }
    }
    
}
