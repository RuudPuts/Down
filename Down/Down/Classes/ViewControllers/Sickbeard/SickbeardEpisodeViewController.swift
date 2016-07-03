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
    
    private enum EpisodeDetailRow {
        case Name
        case AirDate
        case Show
        case Season
        case EpisodeNumber
        
        case Plot
    }
    
    weak var sickbeardService: SickbeardService!
    
    private var episode: SickbeardEpisode!
    private var cellKeys = [[EpisodeDetailRow]]()
    private var cellTitles =  [[String]]()
    
    private var historyItemReplacement: String?
    private var historySwitchRefreshCount = 0
    
    convenience init(sickbeardEpisode: SickbeardEpisode) {
        self.init(nibName: "DownDetailViewController", bundle: nil)
        
        self.episode = sickbeardEpisode
        sickbeardService = serviceManager.sickbeardService
        
        configureTableView()
        title = "Details"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let plotCellNib = UINib(nibName: "DownTextCell", bundle: NSBundle.mainBundle())
        tableView!.registerNib(plotCellNib, forCellReuseIdentifier: "DownTextCell")
        
        setTableViewHeaderImage(episode?.show?.banner ?? UIImage(named: "SickbeardDefaultBanner"))
    }
    
    // MARK: - TableView datasource
    
    func configureTableView() {
        // Section 0
        cellKeys.append([.Name, .AirDate, .Show, .Season, .EpisodeNumber])
        cellTitles.append(["Name", "Aired on", "Show", "Season", "Episode #"])
        
        // Section 1
        cellKeys.append([.Plot])
        cellTitles.append([""])
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellKeys[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            let reuseIdentifier = "episodeCell"
            cell = DownTableViewCell(style: .Value2, reuseIdentifier: reuseIdentifier)
            
            cell.textLabel?.text = cellTitles[indexPath.section][indexPath.row]
            var detailText: String?
            
            switch cellKeys[indexPath.section][indexPath.row] {
                
            case .Name:
                detailText = episode.name
                break
            case .AirDate:
                if let date = episode.airDate {
                    detailText = NSDateFormatter.downDateFormatter().stringFromDate(date)
                }
                else {
                    detailText = "-"
                }
                break
            case .Show:
                detailText = episode.show?.name ?? "-"
                break
            case .Season:
                detailText = episode.season == nil ? "-" : String(episode.season!.id)
                break
            case .EpisodeNumber:
                detailText = String(episode.id)
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
            plotCell.label.text = episode.plot
            
            cell = plotCell
        }
        return cell
    }
    
}