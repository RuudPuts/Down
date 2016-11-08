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

class SickbeardShowViewController: DownDetailViewController, UITableViewDataSource, UITableViewDelegate, SickbeardListener {
    
    var tvdbId = 0
    var show: SickbeardShow? {
        didSet {
            if let tvdbId = show?.tvdbId {
                self.tvdbId = tvdbId
            }
        }
    }
    var isRefreshing = false
    
    var seasons: [SickbeardSeason] {
        get {
            return show?.seasons.reversed() ?? [SickbeardSeason]()
        }
    }
    
    @IBOutlet weak var sectionIndexView: DownSectionIndexView!
    
    var longPressRecognizer: UILongPressGestureRecognizer?
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = show?.name
        refreshShow()
        
        sectionIndexView.datasource = seasons.map { String($0.id) }
        sectionIndexView.tableView = tableView
        
        refreshControl = UIRefreshControl()
        // TODO: UIFont extension
        let titleAttributes = [NSForegroundColorAttributeName: UIColor.downSickbeardColor(), NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:titleAttributes)
        refreshControl!.tintColor = .downSickbeardColor()
        refreshControl!.addTarget(self, action: #selector(refreshShow), for: UIControlEvents.valueChanged)
        tableView!.addSubview(refreshControl!)
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let cellNib = UINib(nibName: "DownTextCell", bundle:nil)
        tableView!.register(cellNib, forCellReuseIdentifier: "DownTextCell")
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        tableView?.addGestureRecognizer(longPressRecognizer!)
        
        if let headerView = tableView!.tableHeaderView as? SickbeardShowHeaderView {
            headerView.show = show
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView!.indexPathForSelectedRow , segue.identifier == "SickbeardEpisode" {
            let season = show?.seasons.reversed()[indexPath.section]
            let episode = season?.episodes.reversed()[indexPath.row]
            
            let detailViewController = segue.destination as! SickbeardEpisodeViewController
            detailViewController.episode = episode
        }
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons[section].episodes.count
    }
    
    func tableView(_ tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return seasons[section].episodes.count == 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let season = seasons[indexPath.section]
        let episode = season.episodes.reversed()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownTextCell", for: indexPath) as! DownTextCell
        cell.setCellType(.Sickbeard)
        cell.label?.text = "\(episode.id). \(episode.name)"
        
        cell.colorViewHidden = false
        cell.colorView.backgroundColor = episode.statusColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SickbeardEpisode", sender: nil)
    }
    
    // MARK: Keeping this for later
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(FLT_EPSILON)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("SickbeardHeaderView", owner: self, options: nil)!.first as! SickbeardHeaderView
        headerView.textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.detailLabel.text = self.tableView(tableView, detailForHeaderInSection: section)
        headerView.setupGestureRecognizer(self, action: #selector(handleHeaderTap(_:)))
        headerView.tag = section
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return seasons[section].title
    }
    
    private func tableView(_ tableView: UITableView, detailForHeaderInSection section: Int) -> String? {
        return String(seasons[section].id)
    }
    
    func handleHeaderTap(_ recogniger: UITapGestureRecognizer) {
        guard let section = recogniger.view?.tag else {
            return
        }
        
        showStateActionSheet(season: seasons[section])
    }
    
    // MARK: Season/Episode state
    
    func longPressHandler() {
        guard let touch = longPressRecognizer?.location(in: tableView),
            let indexPath = tableView?.indexPathForRow(at: touch) else {
            return
        }
        
        let season = seasons[indexPath.section]
        let episode = season.episodes.reversed()[indexPath.row]
        showStateActionSheet(episode: episode)
    }
    
    func showStateActionSheet(episode: SickbeardEpisode) {
        showStateActionSheet(episode.name) { selectedStatus in
            guard episode.status != selectedStatus else {
                return
            }
            
            episode.update(selectedStatus, completion: { error in
                self.tableView?.reloadData()
            })
        }
    }
    
    func showStateActionSheet(season: SickbeardSeason) {
        showStateActionSheet("Season \(season.id)") { selectedStatus in
            season.update(selectedStatus, completion: { error in
                self.tableView?.reloadData()
            })
        }
    }
    
    func showStateActionSheet(_ message: String, completion: @escaping (_ selectedStatus: SickbeardEpisode.SickbeardEpisodeStatus) -> (Void)) {
        let actionSheet = UIAlertController(title: "Set state for", message: message, preferredStyle: .actionSheet)
        
        let states = [SickbeardEpisode.SickbeardEpisodeStatus.Wanted, SickbeardEpisode.SickbeardEpisodeStatus.Skipped,
                      SickbeardEpisode.SickbeardEpisodeStatus.Archived, SickbeardEpisode.SickbeardEpisodeStatus.Ignored]
        for state in states {
            let action = UIAlertAction(title: state.rawValue, style: .default, handler: { (action) in
                completion(state)
            })
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: SickbeardService
    
    func refreshShow() {
        guard let show = show else {
            return
        }
        
        let showName = show.name
        SickbeardService.shared.refreshShow(show) {
            NSLog("Refreshed \(showName), tvdbid \(self.tvdbId)")
            self.show = SickbeardService.shared.showWithId(self.tvdbId)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func sickbeardShowCacheUpdated() {
        tableView?.reloadData()
    }
}

extension SickbeardEpisode {
    
    var statusColor: UIColor {
        get {
            switch status {
            case .Skipped: return UIColor(red:0.38, green:0.53, blue:0.82, alpha:1.00)
            case .Wanted: return UIColor(red:0.73, green:0.33, blue:0.20, alpha:1.00)
            case .Snatched: return UIColor(red:0.55, green:0.38, blue:0.69, alpha:1.00)
            case .Downloaded: return UIColor(red:0.38, green:0.63, blue:0.36, alpha:1.00)
            default: return UIColor(red:0.87, green:0.78, blue:0.25, alpha:1.00)
            }

        }
    }
}

extension SickbeardHeaderView: UIGestureRecognizerDelegate {
    
    func setupGestureRecognizer(_ target: AnyObject, action: Selector) {
        var recognizer = gestureRecognizers?.last as? UITapGestureRecognizer
        if recognizer == nil {
            recognizer = UITapGestureRecognizer(target: target, action: action)
            recognizer!.delegate = self
            addGestureRecognizer(recognizer!)
        }
    }
    
}
