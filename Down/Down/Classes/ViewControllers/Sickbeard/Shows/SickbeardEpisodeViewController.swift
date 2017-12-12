//
//  SickbeardEpisodeViewController.swift
//  Down
//
//  Created by Ruud Puts on 12/19/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import DownKit
import Rswift

class SickbeardEpisodeViewController: DownDetailViewController, UITableViewDataSource, UITableViewDelegate, SickbeardListener {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "Details"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let plotCellNib = UINib(nibName: "DownTextCell", bundle: Bundle.main)
        tableView!.register(plotCellNib, forCellReuseIdentifier: "DownTextCell")
        
        setTableViewHeaderImage(episode?.show?.banner ?? R.image.sickbeardDefaultBanner())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SickbeardService.shared.addListener(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SickbeardService.shared.removeListener(self)
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
        
        guard let episode = episode else {
            return
        }
        
        SickbeardService.shared.fetchEpisodePlot(episode)
        
        // Section 0
        var section0 = [EpisodeDetailDataSource]()
        section0.append(EpisodeDetailDataSource(rowType: .name, title: "Name"))
        section0.append(EpisodeDetailDataSource(rowType: .airDate, title: "Airdate"))
        section0.append(EpisodeDetailDataSource(rowType: .show, title: "Show"))
        section0.append(EpisodeDetailDataSource(rowType: .season, title: "Season"))
        section0.append(EpisodeDetailDataSource(rowType: .episode, title: "Episode"))
        section0.append(EpisodeDetailDataSource(rowType: .status, title: "Status"))
        tableData.append(section0)
        
        if episode.plot.length > 0 {
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
            let font = R.font.openSansLight(size: 14)!
            let maxWidth = view.bounds.width - 34
            
            return episode!.plot.sizeWithFont(font, width:maxWidth).height + 30
        }
        
        return tableView.rowHeight
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
                detailText = episode!.season == nil ? "-" : String(episode!.season!.identifier)
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
        cell.setCellType(.Sickbeard)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        if cellData.rowType == .show {
            performSegue(withIdentifier: "SickbeardShow", sender: nil)
        }
    }
    
    // MARK: SickbeardListener
    
    func sickbeardEpisodeRefreshed(_ episode: SickbeardEpisode) {
        guard let thisEpisode = self.episode, episode.isSame(thisEpisode) else {
            return
        }
        
        self.episode = episode
        configureTableView()
        tableView?.reloadData()
    }
    
}
