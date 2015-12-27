//
//  DownSettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 13/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import DownKit

class DownSettingsViewController: DownViewController, UITableViewDataSource, UITableViewDelegate, DownTableViewCellDegate {
    
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
    
    private var connector: Connector?
    private var cellData = [DownSettingsRow: SettingDataSource]()
    
    private var validatingHost = false
    private var fetchingApiKey = false
    
    convenience init() {
        self.init(nibName: "DownSettingsViewController", bundle: nil)
        
        connector = SabNZBdConnector()
        connector?.host = PreferenceManager.sabNZBdHost
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
        cellData = [DownSettingsRow: SettingDataSource]()
        
        let host = SettingDataSource(rowType: .Host, title: "Host", detailText: "Your SabNZBd host <ip:port>")
        cellData = [.Host: host]
        if connector?.host?.length > 0 && (connector?.apiKey == nil || connector?.apiKey?.length == 0) {
            let username = SettingDataSource(rowType: .Username, title: "Username", detailText: "Your SabNZBd username")
            let password = SettingDataSource(rowType: .Password, title: "Password", detailText: "Your SabNZBd password")
            cellData[.Username] = username
            cellData[.Password] = password
        }
        let apikey = SettingDataSource(rowType: .ApiKey, title: "Api key", detailText: "Your SabNZBd api key")
        cellData[.ApiKey] = apikey
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(tableView: UITableView, shouldShowActivityIndicatorForIndexPath indexPath: NSIndexPath) -> Bool {
        var showIndicator = false
        
        let dataKey: DownSettingsRow = DownSettingsRow(rawValue: indexPath.row)!
        switch dataKey {
        case .Host:
            showIndicator = validatingHost
            break
        case .ApiKey:
            showIndicator = fetchingApiKey
            
        default:
            break
        }
        
        
        return showIndicator
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as! DownTableViewCell
        cell.delegate = self
        cell.setCellType(.SabNZBd)
        
        self.tableView(tableView, reloadCell: cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, reloadCell cell: DownTableViewCell, forIndexPath indexPath: NSIndexPath) -> Void {
        let dataKey: DownSettingsRow = Array(cellData.keys).sort({$0.rawValue < $1.rawValue})[indexPath.row]
        let data = cellData[dataKey]!
        cell.label.text = data.title
        cell.textFieldPlaceholder = data.detailText
        if cell.textField?.text?.length == 0 {
            switch dataKey {
            case .Host:
                var host = PreferenceManager.sabNZBdHost
                if host.hasPrefix("http://") {
                    host = host.stringByReplacingOccurrencesOfString("http://", withString: "")
                }
                cell.textField?.text = host
                break
            case .ApiKey:
                cell.textField?.text = PreferenceManager.sabNZBdApiKey
                break
                
            default:
                break
            }
        }
        
        if self.tableView(tableView, shouldShowActivityIndicatorForIndexPath: indexPath) {
            cell.showActivityIndicator()
        }
        else {
            cell.hideActivityIndicator()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    // MARK - DownTableViewCellDelegate
    
    func downTableViewCell(cell: DownTableViewCell, didChangeText text: String) {
        let indexPath = tableView.indexPathForCell(cell)!
        let rowType: DownSettingsRow = DownSettingsRow(rawValue: indexPath.row)!
        switch rowType {
        case .Host:
            validateHost(text)
            break
        case .Username:
            fetchApiKey()
            break
        case .Password:
            fetchApiKey()
            break
            
        default:
            break
        }
        
        self.tableView(tableView, reloadCell: cell, forIndexPath: indexPath)
    }
    
    // =
    
    func validateHost(var host: String) {
        // check the host, in an ugly way.. NSUrl maybe?
        if !host.hasPrefix("http://") {
            host = "http://" + host
        }
        
        if !validatingHost {
            validatingHost = true
            connector?.validateHost(host, completion: { hostValid, apiKey in
                self.validatingHost = false
                
                if hostValid {
                    PreferenceManager.sabNZBdHost = host.stringByReplacingOccurrencesOfString("http://", withString: "")
                    self.configureTableView()
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                }
                else {
                    let indexPath = NSIndexPath(forRow: DownSettingsRow.Host.rawValue, inSection: 0)
                    let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! DownTableViewCell
                    if let text = cell.textField?.text {
                        if !host.hasSuffix(text) {
                            self.validateHost(text)
                            return
                        }
                    }
                    self.tableView(self.tableView, reloadCell: cell, forIndexPath: indexPath)
                }
            })
        }
    }
    
    func fetchApiKey() {
        let usernameIndexPath = NSIndexPath(forRow: DownSettingsRow.Username.rawValue, inSection: 0)
        let usernameCell = self.tableView.cellForRowAtIndexPath(usernameIndexPath) as! DownTableViewCell
        let username = usernameCell.textField?.text ?? ""
        
        let passwordIndexPath = NSIndexPath(forRow: DownSettingsRow.Password.rawValue, inSection: 0)
        let passwordCell = self.tableView.cellForRowAtIndexPath(passwordIndexPath) as! DownTableViewCell
        let password = passwordCell.textField?.text ?? ""
        
        if !fetchingApiKey && connector?.host?.length > 0 && username.length > 0 && password.length > 0 {
            fetchingApiKey = true
            connector?.fetchApiKey(username: username, password: password, completion: { apiKey in
                if apiKey != nil {
                    PreferenceManager.sabNZBdApiKey = apiKey!
                    self.configureTableView()
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                }
                self.fetchingApiKey = false
            })
        }
    }
}
