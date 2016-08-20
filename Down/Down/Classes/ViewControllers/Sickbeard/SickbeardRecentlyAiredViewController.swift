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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recently aired"
        
        episodes = sickbeardService.getRecentlyAiredEpisodes()
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        let moreCellNib = UINib(nibName: "DownIconTextCell", bundle:nil)
        tableView!.registerNib(moreCellNib, forCellReuseIdentifier: "DownIconTextCell")
        
        let activityCellNib = UINib(nibName: "DownActivityCell", bundle:nil)
        tableView!.registerNib(activityCellNib, forCellReuseIdentifier: "DownActivityCell")
        
        let emtpyCellNib = UINib(nibName: "DownEmptyCell", bundle:nil)
        tableView!.registerNib(emtpyCellNib, forCellReuseIdentifier: "DownEmptyCell")
        
        let itemCellNib = UINib(nibName: "SickbeardTodayCell", bundle:nil)
        tableView!.registerNib(itemCellNib, forCellReuseIdentifier: "SickbeardTodayCell")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView!.indexPathForSelectedRow where segue.identifier == "SickbeardEpisode" {
            let detailViewController = segue.destinationViewController as! SickbeardEpisodeViewController
            detailViewController.episode = episodes[indexPath.row]
        }
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return episodes.count == 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            return tableView.rowHeight
        }
        
        // Width of screen, in 758x140 ratio. 60 extra for labels
        return (CGRectGetWidth(view.bounds) / 758 * 140) + 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            let emptyCell = tableView.dequeueReusableCellWithIdentifier("DownEmptyCell", forIndexPath: indexPath) as! DownEmptyCell
            emptyCell.label?.text = "No shows recently aired."
            
            cell = emptyCell
        }
        else {
            let itemCell = tableView.dequeueReusableCellWithIdentifier("SickbeardTodayCell", forIndexPath: indexPath) as! SickbeardTodayCell
            
            let episode = episodes[indexPath.row]
            itemCell.episodeLabel.text = episode.title
            itemCell.dateLabel.text = episode.airDate?.dateString
            itemCell.bannerView?.image = episode.show?.banner
            
            cell = itemCell
        }
    
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    // MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("SickbeardEpisode", sender: nil)
    }
    
}
