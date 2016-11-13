//
//  ShowsTableViewModel.swift
//  Down
//
//  Created by Ruud Puts on 13/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit

class ShowsTableViewModel: ShowsViewModel, UITableViewDelegate, UITableViewDataSource {
    
    init(_ tableView: UITableView) {
        ["DownTextCell"].forEach {
            let nib = UINib(nibName: $0, bundle: Bundle.main)
            tableView.register(nib, forCellReuseIdentifier: $0)
        }
    }
    
    // MARK: - TableView datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = shows[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownTextCell", for: indexPath) as! DownTextCell
        cell.setCellType(.Sickbeard)
        cell.label.text = show.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.viewModel(self, didSelectShow: shows[indexPath.row])
    }
    
}
