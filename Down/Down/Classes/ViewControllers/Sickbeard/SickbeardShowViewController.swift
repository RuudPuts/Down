//
//  SickbeardShowViewController.swift
//  Down
//
//  Created by Ruud Puts on 8/12/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SickbeardShowViewController: DownDetailViewController, UITableViewDataSource, UITableViewDelegate {
    
    var show: SickbeardShow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = show?.name
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let cellNib = UINib(nibName: "DownTextCell", bundle:nil)
        tableView!.registerNib(cellNib, forCellReuseIdentifier: "DownTextCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        sickbeardService.refreshEpisodesForShow(show!)
        super.viewWillAppear(animated)
        
        setTableViewHeaderImage(show?.banner ?? UIImage(named: "SickbeardDefaultBanner"))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView!.indexPathForSelectedRow where segue.identifier == "SickbeardEpisode" {
            let season = show?.seasons.reverse()[indexPath.section]
            let episode = season?.episodes.reverse()[indexPath.row]
            
            let detailViewController = segue.destinationViewController as! SickbeardEpisodeViewController
            detailViewController.episode = episode
        }
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return show?.seasons.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show!.seasons.reverse()[section].episodes.count
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return show!.seasons.reverse()[section].episodes.count == 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let season = show!.seasons.reverse()[indexPath.section]
        let episode = season.episodes.reverse()[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DownTextCell", forIndexPath: indexPath) as! DownTextCell
        cell.setCellType(.Sickbeard)
        cell.label?.text = "\(episode.id). \(episode.name)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("SickbeardEpisode", sender: nil)
    }
    
    // MARK: Keeping this for later
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (NSBundle.mainBundle().loadNibNamed("SickbeardHeaderView", owner: self, options: nil) as Array).first as! SickbeardHeaderView
        headerView.textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return show!.seasons.reverse()[section].title
    }
    
    // MARK: - TableView Delegate
    
}
