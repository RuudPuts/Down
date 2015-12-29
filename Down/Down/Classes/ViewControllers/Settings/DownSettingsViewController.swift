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
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    var application: DownApplication!
    var delegate: DownSettingsViewControllerDelegate?
    
    private var connector: Connector?
    private var cellData = [DownSettingsRow: SettingDataSource]()
    
    private var validatingHost = false
    private var fetchingApiKey = false
    
    var hostForApplication: String {
        get {
            var host = ""
            switch application as DownApplication {
            case .SabNZBd:
                host = PreferenceManager.sabNZBdHost
                break
            case .Sickbeard:
                host = PreferenceManager.sickbeardHost
                break
            case .CouchPotato:
                host = PreferenceManager.couchPotatoHost
                break
                
            default:
                break
            }
            
            
            if host.hasPrefix("http://") {
                host = host.stringByReplacingOccurrencesOfString("http://", withString: "")
            }
            return host
        }
        set {
            switch application as DownApplication {
            case .SabNZBd:
                PreferenceManager.sabNZBdHost = newValue
                break
            case .Sickbeard:
                PreferenceManager.sickbeardHost = newValue
                break
            case .CouchPotato:
                PreferenceManager.couchPotatoHost = newValue
                break
                
            default:
                break
            }
        }
    }
    
    var apiKeyForApplication: String {
        get {
            var apiKey = ""
            switch application as DownApplication {
            case .SabNZBd:
                apiKey = PreferenceManager.sabNZBdApiKey
                break
            case .Sickbeard:
                apiKey = PreferenceManager.sickbeardApiKey
                break
            case .CouchPotato:
                apiKey = PreferenceManager.couchPotatoApiKey
                break
                
            default:
                break
            }
            
            return apiKey
        }
        set {
            switch application as DownApplication {
            case .SabNZBd:
                PreferenceManager.sabNZBdApiKey = newValue
                break
            case .Sickbeard:
                PreferenceManager.sickbeardApiKey = newValue
                break
            case .CouchPotato:
                PreferenceManager.couchPotatoApiKey = newValue
                break
                
            default:
                break
            }
        }
    }
    
    convenience init(application: DownApplication) {
        self.init(nibName: "DownSettingsViewController", bundle: nil)
        self.application = application
        
        setupConnector()
    }
    
    func setupConnector() {
        connector = SabNZBdConnector()
        switch application as DownApplication {
        case .SabNZBd:
            connector = SabNZBdConnector()
            connector?.host = PreferenceManager.sabNZBdHost
            break;
        case .Sickbeard:
            connector = SickbeardConnector()
            connector?.host = PreferenceManager.sickbeardHost
            break;
            
        default:
            break
        }
        connector?.apiKey = apiKeyForApplication
    }
    
    override func viewDidLoad() {
        configureTableView()
        
        super.viewDidLoad()
        
        applyTheming()
        
        // Nib registering
        let settingsNib = UINib(nibName: "DownSettingsTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(settingsNib, forCellReuseIdentifier: "settingsCell")
    }
    
    func applyTheming() {
        switch application as DownApplication {
        case .SabNZBd:
            headerView.backgroundColor = .downSabNZBdColor()
            headerImageView.image = UIImage(named: "sabnzbd-icon")
            window.statusBarBackgroundColor = .downSabNZBdDarkColor()
            actionButton.setTitleColor(.downSabNZBdColor(), forState: .Normal)
            break
        case .Sickbeard:
            headerView.backgroundColor = .downSickbeardColor()
            headerImageView.image = UIImage(named: "sickbeard-icon")
            window.statusBarBackgroundColor = .downSickbeardDarkColor()
            actionButton.setTitleColor(.downSickbeardColor(), forState: .Normal)
            break
        case .CouchPotato:
            headerView.backgroundColor = .downCouchPotatoColor()
            headerImageView.image = UIImage(named: "couchpotato-icon")
            window.statusBarBackgroundColor = .downCouchPotatoDarkColor()
            actionButton.setTitleColor(.downCouchPotatoColor(), forState: .Normal)
            break
            
        default:
            break
        }
    }
    
    @IBAction func actionButtonPressed(sender: UIButton) {
        delegate?.settingsViewControllerDidTapActionButton(self)
    }
    
    // MARK: - UITableViewDataSource
    
    func configureTableView() {
        cellData = [DownSettingsRow: SettingDataSource]()
        
        let host = SettingDataSource(rowType: .Host, title: "Host", detailText: "Your \(application.rawValue) host <ip:port>")
        cellData = [.Host: host]
        if connector?.host?.length > 0 && (connector?.apiKey == nil || connector?.apiKey?.length == 0) {
            let username = SettingDataSource(rowType: .Username, title: "Username", detailText: "Your \(application.rawValue) username")
            let password = SettingDataSource(rowType: .Password, title: "Password", detailText: "Your \(application.rawValue) password")
            cellData[.Username] = username
            cellData[.Password] = password
        }
        let apikey = SettingDataSource(rowType: .ApiKey, title: "Api key", detailText: "Your \(application.rawValue) api key")
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
        cell.setCellType(application)
        
        self.tableView(tableView, reloadCell: cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, reloadCell cell: DownTableViewCell, forIndexPath indexPath: NSIndexPath) -> Void {
        // If keyboard is open for cell, don't reload
        if cell.textField?.isFirstResponder() == false ?? false {
            let dataKey: DownSettingsRow = Array(cellData.keys).sort({$0.rawValue < $1.rawValue})[indexPath.row]
            let data = cellData[dataKey]!
            
            cell.setCellType(application)
            cell.label.text = data.title
            cell.textFieldPlaceholder = data.detailText
            switch dataKey {
            case .Host:
                cell.textField?.text = hostForApplication
                break
            case .ApiKey:
                cell.textField?.text = apiKeyForApplication
                break
                
            default:
                break
            }
            cell.textField?.secureTextEntry = dataKey == .Password
            
            if self.tableView(tableView, shouldShowActivityIndicatorForIndexPath: indexPath) {
                cell.showActivityIndicator()
            }
            else {
                cell.hideActivityIndicator()
            }
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
                    self.hostForApplication = host.stringByReplacingOccurrencesOfString("http://", withString: "")
                    if apiKey != nil {
                        self.apiKeyForApplication = apiKey!
                    }
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
                if apiKey != nil && apiKey!.length > 0 {
                    self.apiKeyForApplication = apiKey!
                    self.configureTableView()
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                }
                self.fetchingApiKey = false
            })
        }
    }
}

protocol DownSettingsViewControllerDelegate {
    
    func settingsViewControllerDidTapActionButton(viewController: DownSettingsViewController)
    
}
