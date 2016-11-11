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
        case host = 0
        case username = 1
        case password = 2
        case apiKey = 3
    }
    
    struct SettingDataSource {
        var rowType: DownSettingsRow
        var title: String
        var detailText: String
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    
    var application: DownApplication!
    var delegate: DownSettingsViewControllerDelegate?
    
    var connector: Connector?
    var tableData = [SettingDataSource]()
    
    let activityDurationTimeout = TimeInterval(1.0)
    let activityCheckInterval = TimeInterval(0.3)
    var activityCheckTimer: Timer?
    var activityStart = [DownSettingsRow: Date]()
    
    fileprivate var validatingHost = false
    fileprivate var fetchingApiKey = false
    
    var hostForApplication: String {
        get {
            var host = ""
            switch application as DownApplication {
            case .SabNZBd:
                host = Preferences.sabNZBdHost
                break
            case .Sickbeard:
                host = Preferences.sickbeardHost
                break
            case .CouchPotato:
                host = Preferences.couchPotatoHost
                break
                
            default:
                break
            }
            
            
            if host.hasPrefix("http://") {
                host = host.replacingOccurrences(of: "http://", with: "")
            }
            return host
        }
        set {
            switch application as DownApplication {
            case .SabNZBd:
                Preferences.sabNZBdHost = newValue
                break
            case .Sickbeard:
                Preferences.sickbeardHost = newValue
                break
            case .CouchPotato:
                Preferences.couchPotatoHost = newValue
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
                apiKey = Preferences.sabNZBdApiKey
                break
            case .Sickbeard:
                apiKey = Preferences.sickbeardApiKey
                break
            case .CouchPotato:
                apiKey = Preferences.couchPotatoApiKey
                break
                
            default:
                break
            }
            
            return apiKey
        }
        set {
            switch application as DownApplication {
            case .SabNZBd:
                Preferences.sabNZBdApiKey = newValue ?? ""
                break
            case .Sickbeard:
                Preferences.sickbeardApiKey = newValue ?? ""
                break
            case .CouchPotato:
                Preferences.couchPotatoApiKey = newValue ?? ""
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
                service = SabNZBdService.shared
                break
            case .Sickbeard:
                service = SickbeardService.shared
                break
            case .CouchPotato:
                service = CouchPotatoService.shared
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
            connector?.host = Preferences.sabNZBdHost
            break;
        case .Sickbeard:
            connector = SickbeardConnector()
            connector?.host = Preferences.sickbeardHost
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
        let settingsNib = UINib(nibName: "DownSettingsTableViewCell", bundle: Bundle.main)
        tableView!.register(settingsNib, forCellReuseIdentifier: "settingsCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.scanQRCode()
        }
    }
    
    func applyTheming() {
        switch application as DownApplication {
        case .SabNZBd:
            headerView.backgroundColor = .downSabNZBdColor()
            headerImageView.image = UIImage(named: "sabnzbd-icon")
//            window.statusBarBackgroundColor = .downSabNZBdDarkColor()
            actionButton.setTitleColor(.downSabNZBdColor(), for: .normal)
            break
        case .Sickbeard:
            headerView.backgroundColor = .downSickbeardColor()
            headerImageView.image = UIImage(named: "sickbeard-icon")
//            window.statusBarBackgroundColor = .downSickbeardDarkColor()
            actionButton.setTitleColor(.downSickbeardColor(), for: .normal)
            break
        case .CouchPotato:
            headerView.backgroundColor = .downCouchPotatoColor()
            headerImageView.image = UIImage(named: "couchpotato-icon")
//            window.statusBarBackgroundColor = .downCouchPotatoDarkColor()
            actionButton.setTitleColor(.downCouchPotatoColor(), for: .normal)
            break
            
        default:
            break
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        guard let apiKey = apiKeyForApplication, apiKey.length > 0 && hostForApplication.length > 0 else {
            return
        }
        
        applicationService?.startService()
        if let sickbeardService = applicationService as? SickbeardService , Preferences.sickbeardLastCacheRefresh == nil {
            progressLabel.text = "Preparing show cache..."
            progressIndicator.startAnimating()
            progressView.isHidden = false
            
            actionButton.isHidden = true
            sickbeardService.addListener(self)
        }
        else {
            delegate?.settingsViewControllerDidTapActionButton(self)    
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func configureTableView() {
        tableData = [SettingDataSource]()
        tableData.append(SettingDataSource(rowType: .host, title: "Host", detailText: "Your \(application.rawValue) host <ip:port>"))
        
        if let host = connector?.host, host.length > 0, let apiKey = connector?.apiKey, apiKey.length == 0 {
            tableData.append(SettingDataSource(rowType: .username, title: "Username", detailText: "Your \(application.rawValue) username"))
            tableData.append(SettingDataSource(rowType: .password, title: "Password", detailText: "Your \(application.rawValue) password"))
        }
        tableData.append(SettingDataSource(rowType: .apiKey, title: "Api key", detailText: "Your \(application.rawValue) api key"))
    }
    
    func cellTypeForIndexPath(_ indexPath: IndexPath) -> DownSettingsRow {
        return tableData[(indexPath as NSIndexPath).row].rowType
    }
    
    func indexPathForCell(withType cellType: DownSettingsRow) -> IndexPath {
        var rowIndex = 0
        for row in tableData {
            if row.rowType == cellType {
                break
            }
            
            rowIndex += 1
        }
        
        return IndexPath(row: rowIndex, section: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, shouldShowActivityIndicatorForIndexPath indexPath: IndexPath) -> Bool {
        var showIndicator = false
        
        let cellType = cellTypeForIndexPath(indexPath)
        switch cellType {
        case .host:
            showIndicator = validatingHost
            break
        case .apiKey:
            showIndicator = fetchingApiKey
            
        default:
            break
        }
        
        return showIndicator
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! DownTableViewCell
        cell.delegate = self
        cell.setCellType(application)
        
        reloadCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func reloadCell(_ cellType: DownSettingsRow) {
        let indexPath = indexPathForCell(withType: cellType)
        if let visibleRowIndexes = tableView?.indexPathsForVisibleRows , visibleRowIndexes.contains(indexPath) {
            if let cell = tableView?.visibleCells[visibleRowIndexes.index(of: indexPath)!] as? DownTableViewCell {
                reloadCell(cell, forIndexPath: indexPath)
            }
        }
    }
    
    func reloadCell(_ cell: DownTableViewCell, forIndexPath indexPath: IndexPath) -> Void {
        let cellType = cellTypeForIndexPath(indexPath)
        
        // If keyboard is open for cell, don't reload
        if let textField = cell.textField , !textField.isFirstResponder {
            let data = tableData[(indexPath as NSIndexPath).row]
            cell.setCellType(application)
            cell.label.text = data.title
            cell.textFieldPlaceholder = data.detailText
            
            switch cellType {
            case .host:
                cell.textField?.text = hostForApplication
                break
            case .apiKey:
                cell.textField?.text = apiKeyForApplication
                break
                
            default:
                break
            }
            
            cell.textField?.isSecureTextEntry = cellType == .password
        }
        
        if self.tableView(tableView!, shouldShowActivityIndicatorForIndexPath: indexPath) {
            cell.showActivityIndicator()
        }
        else {
            cell.hideActivityIndicator()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK - DownTableViewCellDelegate
    
    func downTableViewCell(_ cell: DownTableViewCell, didChangeText text: String) {
        let indexPath = tableView!.indexPath(for: cell)!
        let cellType = cellTypeForIndexPath(indexPath)
        switch cellType {
        case .host:
            validateHost(text)
            break
        case .username:
            fetchApiKey()
            break
        case .password:
            fetchApiKey()
            break
            
        default:
            break
        }
        
        reloadCell(cell, forIndexPath: indexPath)
    }
    
    // MARK: Activities
    
    func startActivityVerification(_ cellType: DownSettingsRow) {
        activityStart[cellType] = Date()
        activityCheckTimer = Timer.scheduledTimer(timeInterval: activityCheckInterval, target: self, selector: #selector(verifyActivities),
                                                                    userInfo: nil, repeats: true)
    }
    
    func verifyActivities() {
        let now = Date()
        
        tableData.forEach { row in
            if let date = activityStart[row.rowType] , now > date.addingTimeInterval(activityDurationTimeout) {
                activityStart[row.rowType] = nil
                
                switch row.rowType {
                case .host:
                    validatingHost = false
                    break
                case .apiKey:
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
    
    // MARK: Host validation
    
    func validateHost(_ host: String) {
        let hostURL = URL(string: host)
        guard !validatingHost && hostURL != nil && host.length > 0 else {
            return
        }
        
        validatingHost = true
        startActivityVerification(.host)
        connector?.validateHost(hostURL!, completion: { hostValid, apiKey in
            if hostValid {
                self.validatingHost = false
                
                self.hostForApplication = host.replacingOccurrences(of: "http://", with: "")
                self.apiKeyForApplication = apiKey
                
                self.configureTableView()
                self.tableView!.reloadSections(IndexSet([0]), with: .automatic)
            }
            else {
                self.reloadCell(.host)
                
                // Check if user changed input during validation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.revalidateHost(host)
                }
            }
        })
        
        self.reloadCell(.host)
    }
    
    func revalidateHost(_ host: String) {
        let indexPath = self.indexPathForCell(withType: .host)
        let cell = self.tableView?.cellForRow(at: indexPath) as? DownTableViewCell
        
        if let text = cell?.textField?.text {
            if !host.hasSuffix(text) {
                self.validatingHost = false
                self.validateHost(text)
                return
            }
        }
    }
    
    func fetchApiKey() {
        let usernameIndexPath = indexPathForCell(withType: .username)
        let usernameCell = tableView?.cellForRow(at: usernameIndexPath) as? DownTableViewCell
        let username = usernameCell?.textField?.text ?? ""
        
        let passwordIndexPath = indexPathForCell(withType: .password)
        let passwordCell = tableView?.cellForRow(at: passwordIndexPath) as? DownTableViewCell
        let password = passwordCell?.textField?.text ?? ""
        
        if !fetchingApiKey && connector?.host?.length ?? 0 > 0 && username.length > 0 && password.length > 0 {
            fetchingApiKey = true
            startActivityVerification(.apiKey)
            connector?.fetchApiKey(username: username, password: password, completion: { fetchedApiKey in
                if let apiKey = fetchedApiKey , apiKey.length > 0 {
                    self.fetchingApiKey = false
                    
                    self.apiKeyForApplication = fetchedApiKey
                    self.configureTableView()
                    self.tableView!.reloadSections(IndexSet([0]), with: .automatic)
                }
            })
        }
        
        self.reloadCell(.apiKey)
    }
    
    // MARK: QR Code scanner
    
    func scanQRCode() {
        let scanner = DownScanner()
        scanner.scan(hostView: qrCodeView)
    }
    
    // MARK: SickbeardService
    
    func sickbeardShowCacheUpdated() {
        if let sickbeardService = applicationService as? SickbeardService {
            sickbeardService.removeListener(self)
        }
        
        self.actionButton.setTitle("All done, let's go!", for: self.actionButton.state)
        
        self.progressView.isHidden = true
        self.actionButton.isHidden = false
    }
    
}

protocol DownSettingsViewControllerDelegate {
    
    func settingsViewControllerDidTapActionButton(_ viewController: DownSettingsViewController)
    
}
