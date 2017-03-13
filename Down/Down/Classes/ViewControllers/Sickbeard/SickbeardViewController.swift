//
//  SickbeardViewController.swift
//  Down
//
//  Created by Ruud Puts on 05/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import RealmSwift

class SickbeardViewController: DownRootViewController, UITableViewDataSource, UITableViewDelegate, SickbeardListener {
    
    var todayData: Results<SickbeardEpisode>!
    var soonData: Results<SickbeardEpisode>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "Sickbeard"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        registerTableViewCells()
        
        // TODO: Ugly, lol
        if Preferences.sickbeardHost.length == 0 || Preferences.sickbeardApiKey.length == 0 {
            let alertview = UIAlertController(title: nil, message: "Please setup your host using iOS Settings -> Down", preferredStyle: .alert)
            alertview.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            
            present(alertview, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SickbeardService.shared.addListener(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SickbeardService.shared.removeListener(self)
    }
    
    func loadData() {
        todayData = SickbeardService.shared.getEpisodesAiringToday()
        soonData = SickbeardService.shared.getEpisodesAiringSoon()
    }
    
    func registerTableViewCells() {
        let moreCellNib = UINib(nibName: "DownIconTextCell", bundle:nil)
        tableView!.register(moreCellNib, forCellReuseIdentifier: "DownIconTextCell")
        
        let activityCellNib = UINib(nibName: "DownActivityCell", bundle:nil)
        tableView!.register(activityCellNib, forCellReuseIdentifier: "DownActivityCell")
        
        let emtpyCellNib = UINib(nibName: "DownEmptyCell", bundle:nil)
        tableView!.register(emtpyCellNib, forCellReuseIdentifier: "DownEmptyCell")
        
        let itemCellNib = UINib(nibName: "SickbeardTodayCell", bundle:nil)
        tableView!.register(itemCellNib, forCellReuseIdentifier: "SickbeardTodayCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView!.indexPathForSelectedRow , segue.identifier == "SickbeardEpisode" {
            var episode: SickbeardEpisode
            if (indexPath as NSIndexPath).section == 1 {
                episode = todayData[indexPath.row]
            }
            else {
                episode = soonData[indexPath.row]
            }
            
            let detailViewController = segue.destination as! SickbeardEpisodeViewController
            detailViewController.episode = episode
        }
    }
    
    // MARK: - TableView DataSource
    
    fileprivate func reloadTableView() {
        loadData()
        tableView!.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 2
        if soonData != nil {
            sections = 3
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 2
        
        if section == 1 {
            rows = max(todayData.count, 1)
        }
        else if section == 2 {
            rows = max(soonData.count, 1)
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        var isEmpty = false
        
        if section == 1 {
            isEmpty = todayData.count == 0
        }
        else if section == 2 {
            isEmpty = soonData.count == 0
        }
    
        return isEmpty
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = tableView.rowHeight
        
        if (indexPath as NSIndexPath).section > 0 && !self.tableView(tableView, isSectionEmtpy: (indexPath as NSIndexPath).section) {
            // Width of screen, in 758x140 ratio. 60 extra for labels
            height = (view.bounds.width / 758 * 140) + 60
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if (indexPath as NSIndexPath).section > 0 {
            var dataAvailable = true
            if (indexPath as NSIndexPath).section == 2 {
                dataAvailable = soonData != nil
            }

            if !dataAvailable {
                let activityCell = tableView.dequeueReusableCell(withIdentifier: "DownActivityCell", for: indexPath) as! DownTableViewCell
                activityCell.setCellType(.Sickbeard)
                cell = activityCell
            }
            else if self.tableView(tableView, isSectionEmtpy: (indexPath as NSIndexPath).section) {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "DownEmptyCell", for: indexPath) as! DownEmptyCell
                if  (indexPath as NSIndexPath).section == 1 {
                    emptyCell.label?.text = "No shows airing today."
                }
                else {
                    emptyCell.label?.text = "No shows airing soon."
                }
                emptyCell.selectionStyle = .none
                
                cell = emptyCell
            }
            else {
                let itemCell = tableView.dequeueReusableCell(withIdentifier: "SickbeardTodayCell", for: indexPath) as! SickbeardTodayCell
                
                let episode: SickbeardEpisode
                if (indexPath as NSIndexPath).section == 2 {
                    episode = soonData![indexPath.row]
                }
                else {
                    episode = todayData[indexPath.row]
                }
                
                itemCell.episodeLabel.text = episode.title
                itemCell.dateLabel.text = episode.airDate?.dateString
                itemCell.bannerView?.image = episode.show?.banner
                
                cell = itemCell
            }
            
        }
        else {
            let iconTextCell = tableView.dequeueReusableCell(withIdentifier: "DownIconTextCell", for: indexPath) as! DownIconTextCell
            iconTextCell.setCellType(.Sickbeard)
            if (indexPath as NSIndexPath).row == 0 {
                iconTextCell.label?.text = "All shows"
                iconTextCell.iconView?.image = UIImage(named: "sickbeard-allshows")
            }
            else {
                iconTextCell.label?.text = "Recently aired"
                iconTextCell.iconView?.image = UIImage(named: "sickbeard-history")
            }
            cell = iconTextCell
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView? = nil
        
        if section > 0 {
            let header = Bundle.main.loadNibNamed("SickbeardHeaderView", owner: self, options: nil)!.first as! SickbeardHeaderView
            header.textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
            header.imageView.image = self.tableView(tableView, iconForHeaderInSection: section)
            let detailText = section == 1 ? "\((Calendar.current as NSCalendar).components(.day, from: Date()).day)" : "?"
            header.detailLabel.text = detailText
            
            headerView = header
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle: String?
        
        switch section {
        case 1:
            sectionTitle = "Airing today"
            break
        case 2:
            sectionTitle = "Airing soon"
            break
        default:
            break
        }
        
        return sectionTitle
    }
    
    private func tableView(_ tableView: UITableView, iconForHeaderInSection section: Int) -> UIImage? {
        return UIImage(named: "sickbeard-airingtoday")
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            performSegue(withIdentifier: "SickbeardShows", sender: nil)
        }
        else if indexPath == IndexPath(row: 1, section: 0) {
            performSegue(withIdentifier: "SickbeardRecentlyAired", sender: nil)
        }
        else if !self.tableView(tableView, isSectionEmtpy: (indexPath as NSIndexPath).section) {
            performSegue(withIdentifier: "SickbeardEpisode", sender: nil)
        }
    }
    
    // MARK: - SickbeardListener
    
    func sickbeardShowCacheUpdated() {
        reloadTableView()
    }
    
    public func sickbeardShowAdded(_ show: SickbeardShow) {
        reloadTableView()
    }
    
}

extension SickbeardViewController: DownTabBarItem {
    
    var tabIcon: UIImage {
        get {
            return UIImage(named: "sickbeard-tabbar")!
        }
    }
    
    var selectedTabBackground: UIColor {
        get {
            return DownApplication.Sickbeard.color
        }
    }
    
    var deselectedTabBackground: UIColor {
        get {
            return DownApplication.Sickbeard.darkColor
        }
    }
}
