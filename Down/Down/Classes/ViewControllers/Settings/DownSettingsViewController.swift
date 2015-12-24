//
//  DownSettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 13/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

class DownSettingsViewController: DownViewController, UITableViewDataSource, UITableViewDelegate {
    
    private enum DownSettingsRow: Int {
        case Host = 0
        case Username = 1
        case Password = 2
        case ApiKey = 3
    }
    
    private struct SettingDataSource {
        var rowType = DownSettingsRow.Host
        var title = ""
        var detailText = ""
        var isValidatingHost = false
        
        init(rowType: DownSettingsRow, title: String, detailText: String) {
            self.rowType = rowType
            self.title = title
            self.detailText = detailText
        }
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    private var cellData = [DownSettingsRow: SettingDataSource]()
    
    convenience init() {
        self.init(nibName: "DownSettingsViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        configureTableView()
        
        super.viewDidLoad()
        
        // Nib registering
        let settingsNib = UINib(nibName: "DownSettingsTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(settingsNib, forCellReuseIdentifier: "settingsCell")
        
        // Styling
        headerView.backgroundColor = .downSabNZBdColor()
        window.statusBarBackgroundColor = .downSabNZBdDarkColor()
        actionButton.setTitleColor(.downSabNZBdColor(), forState: .Normal)
    }
    
    @IBAction func actionButtonPressed(sender: UIButton) {
    }
    
    // MARK: - UITableViewDataSource
    
    func configureTableView() {
        let host = SettingDataSource(rowType: .Host, title: "Host", detailText: "Your SabNZBd host <ip:port>")
        let username = SettingDataSource(rowType: .Username, title: "Username", detailText: "Your SabNZBd username")
        let password = SettingDataSource(rowType: .Password, title: "Password", detailText: "Your SabNZBd password")
        let apikey = SettingDataSource(rowType: .ApiKey, title: "Api key", detailText: "Your SabNZBd api key")
        
        cellData = [.Host : host, .Username: username, .Password: password, .ApiKey: apikey]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as! DownTableViewCell
        cell.setCellType(.SabNZBd)
        
        let dataKey: DownSettingsRow = DownSettingsRow(rawValue: indexPath.row)!
        let data = cellData[dataKey]!
        cell.label.text = data.title
        cell.textFieldPlaceholder = data.detailText
        
        if dataKey == .Host {
            cell.textField?.text = "192.168..."
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}