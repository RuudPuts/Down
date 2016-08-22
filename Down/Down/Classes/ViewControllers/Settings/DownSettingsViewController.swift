//
//  DownSettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 13/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import DownKit

class DownSettingsViewController: DownViewController, UITableViewDataSource, UITableViewDelegate, DownTableViewCellDegate, SickbeardListener {
    
    enum DownSettingsRow: Int {
        case Host = 0
        case Username = 1
        case Password = 2
        case ApiKey = 3
    }
    
    struct SettingDataSource {
        var rowType: DownSettingsRow
        var title: String
        var detailText: String
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    
    var application: DownApplication!
    var delegate: DownSettingsViewControllerDelegate?
    
    var connector: Connector?
    var tableData = [SettingDataSource]()
    
    let activityDurationTimeout = NSTimeInterval(1.0)
    let activityCheckInterval = NSTimeInterval(0.3)
    var activityCheckTimer: NSTimer?
    var activityStart = [DownSettingsRow: NSDate]()
    
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
    
    var apiKeyForApplication: String? {
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
                PreferenceManager.sabNZBdApiKey = newValue ?? ""
                break
            case .Sickbeard:
                PreferenceManager.sickbeardApiKey = newValue ?? ""
                break
            case .CouchPotato:
                PreferenceManager.couchPotatoApiKey = newValue ?? ""
                break
                
            default:
                break
            }
        }
    }
    
    var applicationService: Service? {
        get {
            var service: Service?
            switch application as DownApplication {
            case .SabNZBd:
                service = serviceManager.sabNZBdService
                break
            case .Sickbeard:
                service = serviceManager.sickbeardService
                break
            case .CouchPotato:
                service = serviceManager.couchPotatoService
                break
                
            default:
                break
            }
            
            return service
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
        tableView!.registerNib(settingsNib, forCellReuseIdentifier: "settingsCell")
    }
    
    func applyTheming() {
        switch application as DownApplication {
        case .SabNZBd:
            headerView.backgroundColor = .downSabNZBdColor()
            headerImageView.image = UIImage(named: "sabnzbd-icon")
//            window.statusBarBackgroundColor = .downSabNZBdDarkColor()
            actionButton.setTitleColor(.downSabNZBdColor(), forState: .Normal)
            break
        case .Sickbeard:
            headerView.backgroundColor = .downSickbeardColor()
            headerImageView.image = UIImage(named: "sickbeard-icon")
//            window.statusBarBackgroundColor = .downSickbeardDarkColor()
            actionButton.setTitleColor(.downSickbeardColor(), forState: .Normal)
            break
        case .CouchPotato:
            headerView.backgroundColor = .downCouchPotatoColor()
            headerImageView.image = UIImage(named: "couchpotato-icon")
//            window.statusBarBackgroundColor = .downCouchPotatoDarkColor()
            actionButton.setTitleColor(.downCouchPotatoColor(), forState: .Normal)
            break
            
        default:
            break
        }
    }
    
    @IBAction func actionButtonPressed(sender: UIButton) {
        guard hostForApplication.length > 0 && apiKeyForApplication?.length > 0 else {
            return
        }
        
        if applicationService is SickbeardService && PreferenceManager.sickbeardLastCacheRefresh == nil {
            progressLabel.text = "Preparing show cache..."
            progressIndicator.startAnimating()
            progressView.hidden = false
            
            actionButton.hidden = true
            if let sickbeardService = applicationService as? SickbeardService {
                sickbeardService.addListener(self)
                sickbeardService.refreshShowCache()
            }
            return
        }
        else {
            applicationService?.startService()
        }
        delegate?.settingsViewControllerDidTapActionButton(self)
    }
    
    // MARK: - UITableViewDataSource
    
    func configureTableView() {
        tableData = [SettingDataSource]()
        tableData.append(SettingDataSource(rowType: .Host, title: "Host", detailText: "Your \(application.rawValue) host <ip:port>"))
        if connector?.host?.length > 0 && (connector?.apiKey == nil || connector?.apiKey?.length == 0) {
            tableData.append(SettingDataSource(rowType: .Username, title: "Username", detailText: "Your \(application.rawValue) username"))
            tableData.append(SettingDataSource(rowType: .Password, title: "Password", detailText: "Your \(application.rawValue) password"))
        }
        tableData.append(SettingDataSource(rowType: .ApiKey, title: "Api key", detailText: "Your \(application.rawValue) api key"))
    }
    
    func cellTypeForIndexPath(indexPath: NSIndexPath) -> DownSettingsRow {
        return tableData[indexPath.row].rowType
    }
    
    func indexPathForCell(withType cellType: DownSettingsRow) -> NSIndexPath {
        var rowIndex = 0
        for row in tableData {
            if row.rowType == cellType {
                break
            }
            
            rowIndex += 1
        }
        
        return NSIndexPath(forRow: rowIndex, inSection: 0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, shouldShowActivityIndicatorForIndexPath indexPath: NSIndexPath) -> Bool {
        var showIndicator = false
        
        let cellType = cellTypeForIndexPath(indexPath)
        switch cellType {
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
        
        reloadCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func reloadCell(cellType: DownSettingsRow) {
        let indexPath = indexPathForCell(withType: cellType)
        if let visibleRowIndexes = tableView?.indexPathsForVisibleRows where visibleRowIndexes.contains(indexPath) {
            if let cell = tableView?.visibleCells[visibleRowIndexes.indexOf(indexPath)!] as? DownTableViewCell {
                reloadCell(cell, forIndexPath: indexPath)
            }
        }
    }
    
    func reloadCell(cell: DownTableViewCell, forIndexPath indexPath: NSIndexPath) -> Void {
        let cellType = cellTypeForIndexPath(indexPath)
        
        // If keyboard is open for cell, don't reload
        if let textField = cell.textField where !textField.isFirstResponder() {
            let data = tableData[indexPath.row]
            cell.setCellType(application)
            cell.label.text = data.title
            cell.textFieldPlaceholder = data.detailText
            
            switch cellType {
            case .Host:
                cell.textField?.text = hostForApplication
                break
            case .ApiKey:
                cell.textField?.text = apiKeyForApplication
                break
                
            default:
                break
            }
            
            cell.textField?.secureTextEntry = cellType == .Password
        }
        
        if self.tableView(tableView!, shouldShowActivityIndicatorForIndexPath: indexPath) {
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
        let indexPath = tableView!.indexPathForCell(cell)!
        let cellType = cellTypeForIndexPath(indexPath)
        switch cellType {
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
        
        reloadCell(cell, forIndexPath: indexPath)
    }
    
    // Activities
    
    func startActivityVerification(cellType: DownSettingsRow) {
        activityStart[cellType] = NSDate()
        activityCheckTimer = NSTimer.scheduledTimerWithTimeInterval(activityCheckInterval, target: self, selector: #selector(verifyActivities),
                                                                    userInfo: nil, repeats: true)
    }
    
    func verifyActivities() {
        let now = NSDate()
        
        tableData.forEach { row in
            if let date = activityStart[row.rowType] where now > date.dateByAddingTimeInterval(activityDurationTimeout) {
                activityStart[row.rowType] = nil
                
                switch row.rowType {
                case .Host:
                    validatingHost = false
                    break
                case .ApiKey:
                    fetchingApiKey = false
                    break
                    
                default:
                    break
                }
                
                reloadCell(row.rowType)
            }
        }
        
        if activityStart.isEmpty {
            activityCheckTimer?.invalidate()
        }
    }
    
    func validateHost(host: String) {
        let hostURL = NSURL(string: host)
        guard !validatingHost && hostURL != nil && host.length > 0 else {
            return
        }
        
        validatingHost = true
        startActivityVerification(.Host)
        connector?.validateHost(hostURL!, completion: { hostValid, apiKey in
            if hostValid {
                self.validatingHost = false
                
                self.hostForApplication = host.stringByReplacingOccurrencesOfString("http://", withString: "")
                self.apiKeyForApplication = apiKey
                
                self.configureTableView()
                self.tableView!.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            }
            else {
                self.reloadCell(.Host)
                
                // Check if user changed input during validation
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.revalidateHost(host)
                }
            }
        })
        
        self.reloadCell(.Host)
    }
    
    func revalidateHost(host: String) {
        let indexPath = self.indexPathForCell(withType: .Host)
        let cell = self.tableView?.cellForRowAtIndexPath(indexPath) as? DownTableViewCell
        
        if let text = cell?.textField?.text {
            if !host.hasSuffix(text) {
                self.validatingHost = false
                self.validateHost(text)
                return
            }
        }
    }
    
    func fetchApiKey() {
        let usernameIndexPath = indexPathForCell(withType: .Username)
        let usernameCell = tableView?.cellForRowAtIndexPath(usernameIndexPath) as? DownTableViewCell
        let username = usernameCell?.textField?.text ?? ""
        
        let passwordIndexPath = indexPathForCell(withType: .Password)
        let passwordCell = tableView?.cellForRowAtIndexPath(passwordIndexPath) as? DownTableViewCell
        let password = passwordCell?.textField?.text ?? ""
        
        if !fetchingApiKey && connector?.host?.length > 0 && username.length > 0 && password.length > 0 {
            fetchingApiKey = true
            startActivityVerification(.ApiKey)
            connector?.fetchApiKey(username: username, password: password, completion: { fetchedApiKey in
                if let apiKey = fetchedApiKey where apiKey.length > 0 {
                    self.fetchingApiKey = false
                    
                    self.apiKeyForApplication = fetchedApiKey
                    self.configureTableView()
                    self.tableView!.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                }
            })
        }
        
        self.reloadCell(.ApiKey)
    }
    
    // MARK: SickbeardService
    
    func sickbeardShowCacheUpdated() {
        if let sickbeardService = applicationService as? SickbeardService {
            sickbeardService.removeListener(self)
        }
        
        self.progressView.hidden = true
        self.actionButton.setTitle("All done, let's go!", forState: self.actionButton.state)
        self.actionButton.hidden = false
    }
    
}

protocol DownSettingsViewControllerDelegate {
    
    func settingsViewControllerDidTapActionButton(viewController: DownSettingsViewController)
    
}
