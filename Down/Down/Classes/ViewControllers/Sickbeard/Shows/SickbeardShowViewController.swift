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
                title = show?.name
            }
        }
    }
    var isRefreshing = false
    
    var seasons: [SickbeardSeason] {
        return show?.seasons.reversed() ?? [SickbeardSeason]()
    }
    
    @IBOutlet weak var sectionIndexView: DownSectionIndexView!
    
    var longPressRecognizer: UILongPressGestureRecognizer?
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshShow()
        
        sectionIndexView.datasource = seasons.map { String($0.identifier) }
        sectionIndexView.tableView = tableView
        
        refreshControl = UIRefreshControl()
        // TODO: UIFont extension
        let titleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.downSickbeardColor(),
                               NSAttributedStringKey.font: R.font.openSans(size: 13)!]
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: titleAttributes)
        refreshControl!.tintColor = .downSickbeardColor()
        refreshControl!.addTarget(self, action: #selector(refreshShow), for: UIControlEvents.valueChanged)
        tableView!.addSubview(refreshControl!)
        
        tableView!.rowHeight = UITableViewAutomaticDimension
        
        let cellNib = UINib(nibName: "DownTextCell", bundle: nil)
        tableView!.register(cellNib, forCellReuseIdentifier: "DownTextCell")
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        tableView?.addGestureRecognizer(longPressRecognizer!)
        
        reloadHeaderView()
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
        if let indexPath = tableView!.indexPathForSelectedRow, segue.identifier == "SickbeardEpisode" {
            let season = show?.seasons.reversed()[indexPath.section]
            let episode = season?.episodes.reversed()[indexPath.row]
            
            let detailViewController = segue.destination as! SickbeardEpisodeViewController
            detailViewController.episode = episode
        }
    }
    
    // MARK: - Header view
    
    func reloadHeaderView() {
        guard let headerView = tableView!.tableHeaderView as? SickbeardShowHeaderView else {
            return
        }
        
        headerView.show = show
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
        cell.setCellType(.sickbeard)
        cell.label?.text = "\(episode.identifier). \(episode.name)"
        
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
        return CGFloat(Float.ulpOfOne)
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
        return String(seasons[section].identifier)
    }
    
    @objc func handleHeaderTap(_ recogniger: UITapGestureRecognizer) {
        guard let section = recogniger.view?.tag else {
            return
        }
        
        showStateActionSheet(season: seasons[section])
    }
    
    // MARK: Season/Episode state
    
    @objc func longPressHandler() {
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
            
            episode.update(selectedStatus, completion: { _ in
                self.tableView?.reloadData()
            })
        }
    }
    
    func showStateActionSheet(season: SickbeardSeason) {
        showStateActionSheet("Season \(season.identifier)") { selectedStatus in
            season.update(selectedStatus, completion: { _ in
                self.tableView?.reloadData()
            })
        }
    }
    
    func showStateActionSheet(_ message: String, completion: @escaping (_ selectedStatus: SickbeardEpisode.Status) -> Void) {
        let actionSheet = UIAlertController(title: "Set state for", message: message, preferredStyle: .actionSheet)
        
        let states: [SickbeardEpisode.Status] = [.wanted, .skipped, .archived, .ignored]
        for state in states {
            let action = UIAlertAction(title: state.rawValue, style: .default, handler: { _ in
                completion(state)
            })
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: SickbeardService
    
    @objc func refreshShow() {
        guard let show = show else {
            return
        }
        
        SickbeardService.shared.refreshShow(show) {
            if $0 != nil {
                self.show = $0
                self.refreshControl?.endRefreshing()
                
                self.reloadHeaderView()
                self.tableView?.reloadData()
            }
            else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func sickbeardShowCacheUpdated() { }
    
}

extension SickbeardEpisode {
    
    var statusColor: UIColor {
        switch status {
        case .skipped: return UIColor(red: 0.38, green: 0.53, blue: 0.82, alpha: 1.00)
        case .wanted: return UIColor(red: 0.73, green: 0.33, blue: 0.20, alpha: 1.00)
        case .snatched: return UIColor(red: 0.55, green: 0.38, blue: 0.69, alpha: 1.00)
        case .downloaded: return UIColor(red: 0.38, green: 0.63, blue: 0.36, alpha: 1.00)
        default: return UIColor(red: 0.87, green: 0.78, blue: 0.25, alpha: 1.00)
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
