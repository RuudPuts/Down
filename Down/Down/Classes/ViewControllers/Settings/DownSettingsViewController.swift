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
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    private var cellData = [DownSettingsRow: String]()
    private var cellDetailData = [DownSettingsRow: String]()
    
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
        cellData = [.Host : "Host", .Username: "Username", .Password: "Password", .ApiKey : "Api key"]
        cellDetailData = [.Host: "Your SabNZBd Host <ip:port>", .Username: "Your SabNZBd username", .Password: "Your SabNZBd password", .ApiKey: "Your SabNZBd api key"]
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
        cell.label.text = cellData[dataKey]
        cell.textFieldPlaceholder = cellDetailData[dataKey]
        
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