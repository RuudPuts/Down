//
//  SickbeardRecentlyAiredViewController.swift
//  Down
//
//  Created by Ruud Puts on 20/08/16.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import RealmSwift

class SickbeardRecentlyAiredViewController: DownViewController, UITableViewDataSource, UITableViewDelegate {
    
    var episodes: Results<SickbeardEpisode>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "Recently aired"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodes = SickbeardService.shared.getRecentlyAiredEpisodes()
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        let moreCellNib = UINib(nibName: "DownIconTextCell", bundle: nil)
        tableView!.register(moreCellNib, forCellReuseIdentifier: "DownIconTextCell")
        
        let activityCellNib = UINib(nibName: "DownActivityCell", bundle: nil)
        tableView!.register(activityCellNib, forCellReuseIdentifier: "DownActivityCell")
        
        let emtpyCellNib = UINib(nibName: "DownEmptyCell", bundle: nil)
        tableView!.register(emtpyCellNib, forCellReuseIdentifier: "DownEmptyCell")
        
        let itemCellNib = UINib(nibName: "SickbeardTodayCell", bundle: nil)
        tableView!.register(itemCellNib, forCellReuseIdentifier: "SickbeardTodayCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView!.indexPathForSelectedRow, segue.identifier == "SickbeardEpisode" {
            let detailViewController = segue.destination as! SickbeardEpisodeViewController
            detailViewController.episode = episodes[indexPath.row]
        }
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return episodes.count == 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableView(tableView, isSectionEmtpy: (indexPath as NSIndexPath).section) {
            return tableView.rowHeight
        }
        
        // Width of screen, in 758x140 ratio. 60 extra for labels
        return (view.bounds.width / 758 * 140) + 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if self.tableView(tableView, isSectionEmtpy: (indexPath as NSIndexPath).section) {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "DownEmptyCell", for: indexPath) as! DownEmptyCell
            emptyCell.label?.text = "No shows recently aired."
            
            cell = emptyCell
        }
        else {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "SickbeardTodayCell", for: indexPath) as! SickbeardTodayCell
            
            let episode = episodes[indexPath.row]
            itemCell.episodeLabel.text = episode.title
            itemCell.dateLabel.text = episode.airDate?.dateString
            itemCell.bannerView?.image = episode.show?.banner
            
            cell = itemCell
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SickbeardEpisode", sender: nil)
    }
    
}
