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
        super.viewDidLoad()
        
        navigationController?.setupForApplication(.Sickbeard)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
