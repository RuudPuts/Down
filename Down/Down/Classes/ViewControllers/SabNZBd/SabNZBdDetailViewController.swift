//
//  SabNZBdDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 12/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

class SabNZBdDetailViewController: ViewController, UITableViewDataSource, UITableViewDelegate, SabNZBdListener {
    
    weak var sabNZBdService: SabNZBdService!
    
    private var item: SABItem!
    
    convenience init(sabItem: SABItem) {
        self.init(nibName: "SabNZBdDetailViewController", bundle: nil)
        
        item = sabItem
        sabNZBdService = serviceManager.sabNZBdService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        sabNZBdService.addListener(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        sabNZBdService.removeListener(self)
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - TableView datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - SabNZBdListener
    
    func sabNZBdQueueUpdated() {
        self.tableView.reloadData()
    }
    
    func sabNZBdHistoryUpdated() {
        self.tableView.reloadData()
    }
    
    func sabNZBDFullHistoryFetched() { }
    
}