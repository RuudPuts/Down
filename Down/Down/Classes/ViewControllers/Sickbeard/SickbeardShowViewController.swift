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
    
    weak var sickbeardService: SickbeardService!
    weak var show: SickbeardShow!
    
    convenience init() {
        self.init(nibName: "DownDetailViewController", bundle: nil)
        
        sickbeardService = serviceManager.sickbeardService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "DownTextCell", bundle:nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "DownTextCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        title = show.name
        
        super.viewWillAppear(animated)
        
        tableView.tableHeaderView = UIImageView(image: show.banner ?? UIImage(named: "SickbeardDefaultBanner"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let headerView = tableView.tableHeaderView as! UIImageView
        headerView.contentMode = .ScaleAspectFit
        let tableWidth = CGRectGetHeight(tableView.bounds)
        let imageWidth = headerView.image?.size.width ?? 0
        let imageHeight = headerView.image?.size.height ?? 0
        let headerViewHeight = imageWidth / tableWidth * imageHeight
        headerView.frame = CGRectMake(0,0, tableWidth, headerViewHeight);
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return show.seasons.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show.seasons[section].episodes.count
    }
    
    func tableView(tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return show.seasons[section].episodes.count == 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let season = show.seasons[indexPath.section]
        let episode = season.episodes[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DownTextCell", forIndexPath: indexPath) as! DownTextCell
        cell.setCellType(.Sickbeard)
        cell.label?.text = "\(episode.id). \(episode.name)"
        
        return cell
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
        return "Season \(show.seasons[section].id)"
    }
    
    // MARK: - TableView Delegate
    
}
