//
//  SicbkeardAddShowViewController.swift
//  Down
//
//  Created by Ruud Puts on 25/09/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import DownKit

class SicbkeardAddShowViewController: DownDetailViewController, UITableViewDataSource, UITableViewDelegate {
    
    var shows = [SickbeardShow]()
    
    override func viewDidLoad() {
        self.viewDidLoad()
    }

    // MARK: TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
