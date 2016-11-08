//
//  SabNZBdHistoryViewController.swift
//  Down
//
//  Created by Ruud Puts on 10/05/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation
import DownKit

class SabNZBdHistoryViewController: DownDetailViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        
        let activityCellNib = UINib(nibName: "DownActivityCell", bundle:nil)
        tableView!.register(activityCellNib, forCellReuseIdentifier: "DownActivityCell")
        
        let emtpyCellNib = UINib(nibName: "DownEmptyCell", bundle:nil)
        tableView!.register(emtpyCellNib, forCellReuseIdentifier: "DownEmptyCell")
        
        let itemCellNib = UINib(nibName: "SABItemCell", bundle:nil)
        tableView!.register(itemCellNib, forCellReuseIdentifier: "SABItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SabNZBdService.shared.addListener(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SabNZBdService.shared.removeListener(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView!.indexPathForSelectedRow , segue.identifier == "SabNZBdDetail" {
            let selectedItem = SabNZBdService.shared.history[indexPath.row];
            
            let detailViewController = segue.destination as! SabNZBdDetailViewController
            detailViewController.sabItem = selectedItem
        }
    }
    
    // MARK: - TableView datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = SabNZBdService.shared.history.count
        if !SabNZBdService.shared.fullHistoryFetched {
            numberOfRows += 1
        }
        return max(numberOfRows, 1)
    }
    
    func tableView(_ tableView: UITableView, isSectionEmtpy section: Int) -> Bool {
        return SabNZBdService.shared.history.count == 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: Float = 60
        if !self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if indexPath.row < SabNZBdService.shared.history.count {
                let historyItem: SABHistoryItem = SabNZBdService.shared.history[indexPath.row];
                if historyItem.hasProgress {
                    rowHeight = 66.0
                }
            }
        }
        
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if self.tableView(tableView, isSectionEmtpy: indexPath.section) {
            if SabNZBdService.shared.lastRefresh != nil {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "DownEmptyCell", for: indexPath) as! DownEmptyCell
                emptyCell.label?.text = "Your History is empty."
                cell = emptyCell
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "DownLoadingCell", for: indexPath)
            }
        }
        else if indexPath.row == SabNZBdService.shared.history.count && !SabNZBdService.shared.fullHistoryFetched {
            let activityCell = tableView.dequeueReusableCell(withIdentifier: "DownActivityCell", for: indexPath) as! DownTableViewCell
            activityCell.setCellType(.SabNZBd)
            activityCell.label?.text = "Loading..."
            
            cell = activityCell
        }
        else {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "SABItemCell", for: indexPath) as! SABItemCell
            let historyItem: SABHistoryItem = SabNZBdService.shared.history[indexPath.row];
            itemCell.historyItem = historyItem
            
            cell = itemCell
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.numberOfRows(inSection: indexPath.section) > 0 && indexPath.row == SabNZBdService.shared.history.count {
            SabNZBdService.shared.fetchHistory()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item: SABHistoryItem = SabNZBdService.shared.history[indexPath.row]
        SabNZBdService.shared.deleteItem(item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SabNZBdDetail", sender: nil)
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        tableView!.reloadData()
    }
    
    func sabNZBdHistoryUpdated() {
        tableView!.reloadData()
    }
    
    func sabNZBDFullHistoryFetched() {
        tableView!.reloadData()
    }
    
    func willRemoveSABItem(_ sabItem: SABItem) {
        if sabItem is SABHistoryItem {
            tableView!.reloadData()
        }
    }
    
}
