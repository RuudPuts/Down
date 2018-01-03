//
//  DownSettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 13/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import DownKit
import Rswift

// swiftlint:disable type_body_length
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
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    
    weak var delegate: DownSettingsViewControllerDelegate?
    
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
            case .sabNZBd:
                host = Preferences.sabNZBdHost ?? ""
            case .sickbeard:
                host = Preferences.sickbeardHost ?? ""
            case .couchPotato:
                host = Preferences.couchPotatoHost
            default: break
            }

            if host.hasPrefix("http://") {
                host = host.replacingOccurrences(of: "http://", with: "")
            }
            return host
        }
        set {
            switch application as DownApplication {
            case .sabNZBd:
                Preferences.sabNZBdHost = newValue
            case .sickbeard:
                Preferences.sickbeardHost = newValue
            case .couchPotato:
                Preferences.couchPotatoHost = newValue
            default: break
            }
        }
    }
    
    var apiKeyForApplication: String? {
        get {
            switch application as DownApplication {
            case .sabNZBd: return Preferences.sabNZBdApiKey
            case .sickbeard: return Preferences.sickbeardApiKey
            case .couchPotato: return Preferences.couchPotatoApiKey
            default: return nil
            }
        }
        set {
            switch application as DownApplication {
            case .sabNZBd:
                Preferences.sabNZBdApiKey = newValue ?? ""
            case .sickbeard:
                Preferences.sickbeardApiKey = newValue ?? ""
            case .couchPotato:
                Preferences.couchPotatoApiKey = newValue ?? ""
            default: break
            }
        }
    }
    
    var applicationService: Service? {
        switch application as DownApplication {
        case .sabNZBd: return SabNZBdService.shared
        case .sickbeard: return SickbeardService.shared
        case .couchPotato: return CouchPotatoService.shared
        default: return nil
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
        case .sabNZBd:
            connector = SabNZBdConnector()
            connector?.host = Preferences.sabNZBdHost
        case .sickbeard:
            connector = SickbeardConnector()
            connector?.host = Preferences.sickbeardHost
        default: break
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
        
        if hostForApplication.length > 0 && apiKeyForApplication == nil {
            validateHost(hostForApplication)
        }
    }
    
    func applyTheming() {
        switch application as DownApplication {
        case .sabNZBd:
            headerView.backgroundColor = .downSabNZBdColor()
            headerImageView.image = R.image.sabnzbdIcon()
//            window.statusBarBackgroundColor = .downSabNZBdDarkColor()
            actionButton.setTitleColor(.downSabNZBdColor(), for: .normal)
        case .sickbeard:
            headerView.backgroundColor = .downSickbeardColor()
            headerImageView.image = R.image.sickbeardIcon()
//            window.statusBarBackgroundColor = .downSickbeardDarkColor()
            actionButton.setTitleColor(.downSickbeardColor(), for: .normal)
        case .couchPotato:
            headerView.backgroundColor = .downCouchPotatoColor()
            headerImageView.image = R.image.couchpotatoIcon()
//            window.statusBarBackgroundColor = .downCouchPotatoDarkColor()
            actionButton.setTitleColor(.downCouchPotatoColor(), for: .normal)
        default: break
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        guard let apiKey = apiKeyForApplication, apiKey.length > 0 && hostForApplication.length > 0 else {
            return
        }
        
        applicationService?.startService()
        if let sickbeardService = applicationService as? SickbeardService {
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
        
        if hostForApplication.length > 0, apiKeyForApplication == nil || apiKeyForApplication!.length == 0 {
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
        case .apiKey:
            showIndicator = fetchingApiKey
        default: break
        }
        
        return showIndicator
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! DownTableViewCell
        cell.delegate = self
        cell.setCellType(application)
        cell.backgroundColor = .clear
        
        reloadCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func reloadCell(_ cellType: DownSettingsRow) {
        let indexPath = indexPathForCell(withType: cellType)
        if let visibleRowIndexes = tableView?.indexPathsForVisibleRows, visibleRowIndexes.contains(indexPath) {
            if let cell = tableView?.visibleCells[visibleRowIndexes.index(of: indexPath)!] as? DownTableViewCell {
                reloadCell(cell, forIndexPath: indexPath)
            }
        }
    }
    
    func reloadCell(_ cell: DownTableViewCell, forIndexPath indexPath: IndexPath) {
        let cellType = cellTypeForIndexPath(indexPath)
        
        // If keyboard is public for cell, don't reload
        if let textField = cell.textField, !textField.isFirstResponder {
            let data = tableData[(indexPath as NSIndexPath).row]
            cell.setCellType(application)
            cell.label.text = data.title
            cell.textFieldPlaceholder = data.detailText
            
            switch cellType {
            case .host:
                cell.textField?.text = hostForApplication
            case .apiKey:
                cell.textField?.text = apiKeyForApplication
            default: break
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
    
    // MARK: - DownTableViewCellDelegate
    
    func downTableViewCell(_ cell: DownTableViewCell, didChangeText text: String) {
        let indexPath = tableView!.indexPath(for: cell)!
        let cellType = cellTypeForIndexPath(indexPath)
        switch cellType {
        case .host:
            validateHost(text)
        case .username:
            fetchApiKey()
        case .password:
            fetchApiKey()
            // TODO: add case for apikey to verify it
        default: break
        }
        
        reloadCell(cell, forIndexPath: indexPath)
    }
    
    // Activities
    
    func startActivityVerification(_ cellType: DownSettingsRow) {
        activityStart[cellType] = Date()
        activityCheckTimer = Timer.scheduledTimer(timeInterval: activityCheckInterval, target: self, selector: #selector(verifyActivities),
                                                                    userInfo: nil, repeats: true)
    }
    
    @objc func verifyActivities() {
        let now = Date()
        
        tableData.forEach { row in
            if let date = activityStart[row.rowType], now > date.addingTimeInterval(activityDurationTimeout) {
                activityStart[row.rowType] = nil
                
                switch row.rowType {
                case .host:
                    validatingHost = false
                case .apiKey:
                    fetchingApiKey = false
                default: break
                }
                
                reloadCell(row.rowType)
            }
        }
        
        if activityStart.isEmpty {
            activityCheckTimer?.invalidate()
        }
    }
    
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
                UIDevice.hapticFeedback(.smallTick)
                
                self.hostForApplication = host.replacingOccurrences(of: "http://", with: "")
                self.apiKeyForApplication = apiKey
                
                self.configureTableView()
                self.tableView!.reloadSections(IndexSet([0]), with: .automatic)
            }
            else {
                self.reloadCell(.host)
            }
            
            // Check if user changed input during validation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.revalidateHost(host)
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
        let (username, password) = getCredentials()
        
        if !fetchingApiKey && connector?.host?.length ?? 0 > 0 && username.length > 0 && password.length > 0 {
            fetchingApiKey = true
            startActivityVerification(.apiKey)
            connector?.fetchApiKey(username: username, password: password, completion: { fetchedApiKey in
                if let apiKey = fetchedApiKey, apiKey.length > 0 {
                    self.fetchingApiKey = false
                    UIDevice.hapticFeedback(.smallTick)

                    self.apiKeyForApplication = fetchedApiKey
                    self.configureTableView()
                    self.tableView!.reloadSections(IndexSet([0]), with: .automatic)
                }
                else {
                    self.reloadCell(.apiKey)
                }
                
                // Check if user changed input during validation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.revalidateCredentials(username, password)
                }
            })
        }
        
        self.reloadCell(.apiKey)
    }
    
    func revalidateCredentials(_ username: String, _ password: String) {
        let (curUsername, curPassword) = getCredentials()
        
        if !(curUsername == username) || !(curPassword == password) {
            self.fetchingApiKey = false
            self.fetchApiKey()
            return
        }
    }
    
    func getCredentials() -> (String, String) {
        let usernameIndexPath = indexPathForCell(withType: .username)
        let usernameCell = tableView?.cellForRow(at: usernameIndexPath) as? DownTableViewCell
        let username = usernameCell?.textField?.text ?? ""
        
        let passwordIndexPath = indexPathForCell(withType: .password)
        let passwordCell = tableView?.cellForRow(at: passwordIndexPath) as? DownTableViewCell
        let password = passwordCell?.textField?.text ?? ""
        
        return (username, password)
    }
    
    // MARK: SickbeardService
    
    func sickbeardShowCacheUpdated() {
        UIDevice.hapticFeedback(.doubleTick)
        
        if let sickbeardService = applicationService as? SickbeardService {
            sickbeardService.removeListener(self)
        }
        
        // Perform the original action
        delegate?.settingsViewControllerDidTapActionButton(self)
    }
}

protocol DownSettingsViewControllerDelegate: class {
    func settingsViewControllerDidTapActionButton(_ viewController: DownSettingsViewController)
// swiftlint:disable file_length
}
