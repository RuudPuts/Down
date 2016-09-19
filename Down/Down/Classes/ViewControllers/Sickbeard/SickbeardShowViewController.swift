//
//  SickbeardShowViewController.swift
//  Down
//
//  Created by Ruud Puts on 8/12/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import RealmSwift

class SickbeardShowViewController: DownDetailViewController, UITableViewDataSource, UITableViewDelegate {
    
    var show: SickbeardShow?
    var seasons: [SickbeardSeason]?
    
    var longPressRecognizer: UILongPressGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = show?.name
        seasons = show?.seasons.reverse()
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let cellNib = UINib(nibName: "DownTextCell", bundle:nil)
        tableView!.registerNib(cellNib, forCellReuseIdentifier: "DownTextCell")
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        tableView?.addGestureRecognizer(longPressRecognizer!)
        
        if let headerView = tableView!.tableHeaderView as? SickbeardShowHeaderView {
            headerView.show = show
        }
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
        return seasons?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons![section].episodes.count
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return seasons![section].episodes.count == 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let season = seasons![indexPath.section]
        let episode = season.episodes.reverse()[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DownTextCell", forIndexPath: indexPath) as! DownTextCell
        cell.setCellType(.Sickbeard)
        cell.label?.text = "\(episode.id). \(episode.name)"
        
        cell.colorViewHidden = false
        cell.colorView.backgroundColor = episode.statusColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("SickbeardEpisode", sender: nil)
    }
    
    // MARK: Keeping this for later
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(FLT_EPSILON)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (NSBundle.mainBundle().loadNibNamed("SickbeardHeaderView", owner: self, options: nil) as Array).first as! SickbeardHeaderView
        headerView.textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.detailLabel.text = self.tableView(tableView, detailForHeaderInSection: section)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return seasons![section].title
    }
    
    func tableView(tableView: UITableView, detailForHeaderInSection section: Int) -> String? {
        return String(seasons![section].id)
    }
    
    // MARK: Season/Episode state
    
    func longPressHandler() {
        guard let touch = longPressRecognizer?.locationInView(view),
            let indexPath = tableView?.indexPathForRowAtPoint(touch) else {
            return
        }
        
        let season = seasons![indexPath.section]
        let episode = season.episodes.reverse()[indexPath.row]
        showStateActionSheet(episode: episode)
    }
    
    func showStateActionSheet(episode episode: SickbeardEpisode) {
        showStateActionSheet(episode.name) {
            print("Selected \($0)")
        }
    }
    
    func showStateActionSheet(message: String, completion: (selectedStatus: SickbeardEpisode.SickbeardEpisodeStatus) -> (Void)) {
        let actionSheet = UIAlertController(title: "Set state for", message: message, preferredStyle: .ActionSheet)
        
        let states = [SickbeardEpisode.SickbeardEpisodeStatus.Wanted, SickbeardEpisode.SickbeardEpisodeStatus.Skipped,
                      SickbeardEpisode.SickbeardEpisodeStatus.Archived, SickbeardEpisode.SickbeardEpisodeStatus.Ignored]
        for state in states {
            let action = UIAlertAction(title: state.rawValue, style: .Default, handler: { (action) in
                completion(selectedStatus: state)
            })
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}

extension SickbeardEpisode {
    
    var statusColor: UIColor {
        get {
            guard let showStatus = SickbeardEpisodeStatus(rawValue: status) else {
                return .clearColor()
            }
            
            switch showStatus {
            case .Ignored, .Archived, .Unaired: return UIColor(red:0.87, green:0.78, blue:0.25, alpha:1.00)
            case .Skipped: return UIColor(red:0.38, green:0.53, blue:0.82, alpha:1.00)
            case .Wanted: return UIColor(red:0.73, green:0.33, blue:0.20, alpha:1.00)
            case .Snatched: return UIColor(red:0.55, green:0.38, blue:0.69, alpha:1.00)
            case .Downloaded: return UIColor(red:0.38, green:0.63, blue:0.36, alpha:1.00)
            }

        }
    }
}
