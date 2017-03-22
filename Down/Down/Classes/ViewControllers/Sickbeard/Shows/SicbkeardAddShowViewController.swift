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
    var webViewController: DownWebViewController?
    var rightBarButton = DownBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setupForApplication(.Sickbeard)
        navigationItem.rightBarButtonItem = rightBarButton
        
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
        
        let states: [SickbeardEpisode.Status] = [.Wanted, .Skipped, .Archived, .Ignored]
        for state in states {
            let action = UIAlertAction(title: state.rawValue, style: .default, handler: { (action) in
                self.addShow(show, initialState: state)
            })
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func addShow(_ show: SickbeardShow, initialState state: SickbeardEpisode.Status) {
//        webViewController?.rightBarButton.isSpinning = true
        self.overlay.status = "Adding '\(show.name)'"
        self.showOverlay()
        
        SickbeardService.shared.addShow(show, initialState: state) { (success, addedShow) in
            guard success else {
                self.hideOverlay()
                // TODO: Add error result to overlay
                self.showError("There was an error while adding the show. It might already be added")
                self.webViewController?.rightBarButton.isSpinning = false
                
                return
            }
            
            self.overlay.complete(withResult: .success)

            // TODO: Cleanup, autohide in spinner
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: {
//                // TODO: Completion closure for hideOverlay
                self.hideOverlay()
            })
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                self.delegate?.addShowViewController(viewController: self, didAddShow: addedShow!)
            })
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Whoops..", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: ShowsViewModelDelegate
    
    func viewModel(_ model: ShowsViewModel, didSelectShow show: SickbeardShow) {
        let showDetailUrl = URL(string: "https://thetvdb.com/?tab=series&id=\(show.tvdbId)")!
        
        let controller = DownWebViewController()
        controller.url = showDetailUrl
        controller.title = show.name
        controller.rightBarButton.title = "Add"
        controller.rightBarButton.touchClosure = {
            self.showAddShowActionSheet(for: show)
        }
        webViewController = controller
        
        navigationController?.pushViewController(webViewController!, animated: true)
    }
    
    
    
    
    
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//    self.overlay.status = "Testing overlay  🚀"
//    self.showOverlay()
//    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//    self.overlay.complete(withResult: .success)
//    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 4.5, execute: {
//    self.hideOverlay()
//    })
//    }
//    }
    
}

protocol SicbkeardAddShowViewControllerDelegate {
    func addShowViewController(viewController: SicbkeardAddShowViewController, didAddShow show: SickbeardShow);
}

extension SicbkeardAddShowViewController { // UISearchBarDelegate
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        rightBarButton.isSpinning = true
        SickbeardService.shared.searchForShow(query: searchText) { foundShows in
            self.tableViewModel!.shows = foundShows
            
            self.tableView?.reloadData()
            self.searchBar?.becomeFirstResponder()
            self.rightBarButton.isSpinning = false
        }
        
        super.searchBar(searchBar, textDidChange: searchText)
    }
    
}
