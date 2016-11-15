//
//  SicbkeardAddShowViewController.swift
//  Down
//
//  Created by Ruud Puts on 25/09/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import DownKit

class SicbkeardAddShowViewController: DownDetailViewController, ShowsViewModelDelegate {
    
    var tableViewModel: ShowsTableViewModel?
    var delegate: SicbkeardAddShowViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setupForApplication(.Sickbeard)
        
        guard let tableView = tableView else {
            return
        }
        
        addSearchBar()
        searchBar?.showsCancelButton = false
        
        tableViewModel = ShowsTableViewModel(tableView)
        tableViewModel?.delegate = self
        tableView.dataSource = tableViewModel!
        tableView.delegate = tableViewModel!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchBar?.becomeFirstResponder()
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        self.searchBar?.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func showAddShowActionSheet(for show: SickbeardShow) {
        let actionSheet = UIAlertController(title: "Add show '\(show.name)'?", message: "Select initial episode state", preferredStyle: .actionSheet)
        
        let states: [SickbeardEpisode.SickbeardEpisodeStatus] = [.Wanted, .Skipped, .Archived, .Ignored]
        for state in states {
            let action = UIAlertAction(title: state.rawValue, style: .default, handler: { (action) in
                self.addShow(show, initialState: state)
            })
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func addShow(_ show: SickbeardShow, initialState state: SickbeardEpisode.SickbeardEpisodeStatus) {
        SickbeardService.shared.addShow(show, initialState: state) { (success, addedShow) in
            if addedShow != nil {
                self.delegate?.addShowViewController(viewController: self, didAddShow: addedShow!)
            }
        }
    }
    
    // MARK: ShowsViewModelDelegate
    
    func viewModel(_ model: ShowsViewModel, didSelectShow show: SickbeardShow) {
        showAddShowActionSheet(for: show)
    }
    
}

protocol SicbkeardAddShowViewControllerDelegate {
    func addShowViewController(viewController: SicbkeardAddShowViewController, didAddShow show: SickbeardShow);
}

extension SicbkeardAddShowViewController { // UISearchBarDelegate
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SickbeardService.shared.searchForShow(query: searchText) { foundShows in
            self.tableViewModel!.shows = foundShows
            
            self.tableView?.reloadData()
            self.searchBar?.becomeFirstResponder()
        }
        
        super.searchBar(searchBar, textDidChange: searchText)
    }
    
}
