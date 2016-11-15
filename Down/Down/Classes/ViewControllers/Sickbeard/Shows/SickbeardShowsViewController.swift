//
//  SickbeardShowsViewController.swift
//  Down
//
//  Created by Ruud Puts on 19/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import RealmSwift

class SickbeardShowsViewController: DownDetailViewController, ShowsViewModelDelegate, DownSectionIndexViewDelegate, SickbeardListener {
    
    var collectionViewModel: ShowsCollectionViewModel?
    var longPressRecognizer: UILongPressGestureRecognizer?
    
    @IBOutlet weak var sectionIndexView: DownSectionIndexView!
    
    let SymbolSectionTitle = "#"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shows"
        
        guard let collectionView = collectionView else {
            return
        }
        
        addSearchBar()
        
        collectionView.backgroundColor = .downLightGrayColor()
        
        collectionViewModel = ShowsCollectionViewModel(collectionView)
        collectionViewModel?.delegate = self
        collectionView.dataSource = collectionViewModel!
        collectionView.delegate = collectionViewModel!
        
        sectionIndexView.delegate = self
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        collectionView.addGestureRecognizer(longPressRecognizer!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadShows()
        
        SickbeardService.shared.addListener(self)
        collectionViewModel!.preheatController.enabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SickbeardService.shared.removeListener(self)
        // When you disable preheat controller it removes all preheating
        // index paths and calls its handler
        collectionViewModel!.preheatController.enabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView!.indexPathsForSelectedItems?.first , segue.identifier == "SickbeardShow" {
            let show = collectionViewModel?.shows[indexPath.item]
            
            let detailViewController = segue.destination as! SickbeardShowViewController
            detailViewController.show = show
        }
    }
    
    func reloadShows() {
        if let searchText = searchBar?.text?.trimmed, searchText.length > 0 {
            filterShows(searchText)
        }
        else {
            loadAllShows()
        }
    }
    
    func loadAllShows() {
        NSLog("[SickbeardShowsViewController] Reloading shows")
        let symbolPrefixes = ["'", "\\", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        var sectionTitles = [String]()
        
        let allShows = DownDatabase.shared.fetchAllSickbeardShows()
        allShows.forEach() { show in           
            var sectionTitle = show.nameWithoutPrefix.substring(0..<1).uppercased()
            if symbolPrefixes.contains(sectionTitle) {
                sectionTitle = SymbolSectionTitle
            }
            
            sectionTitles.append(sectionTitle)
        }
        sectionTitles = Array(Set(sectionTitles)).sorted { $0 < $1 }
        
        collectionViewModel!.shows = Array(allShows).sorted(by: { $0.nameWithoutPrefix.uppercased() < $1.nameWithoutPrefix.uppercased() })
        sectionIndexView.datasource = sectionTitles
    }
    
    func filterShows(_ searchText: String) {
        var foundShows = DownDatabase.shared.fetchAllSickbeardShows()
        if searchText.length > 0 {
            foundShows = foundShows.filter("_simpleName contains[c] %@", searchText)
        }
        collectionViewModel!.shows = Array(foundShows)
    }
    
    // MARK: ShowsViewModelDelegate
    
    func viewModel(_ model: ShowsViewModel, didSelectShow show: SickbeardShow) {
        performSegue(withIdentifier: "SickbeardShow", sender: nil)
    }
    
    // MARK: SectionIndexView
    
    func sectionIndexView(_ sectionIndexView: DownSectionIndexView, didSelectSection section: String, atIndex index: Int) {
        var indexPath = IndexPath(item: 0, section: 0)
        if (section != SymbolSectionTitle) {
            // Find first show with selected section title as first character
            let firstShow = collectionViewModel!.shows.filter { $0.nameWithoutPrefix.substring(0..<1).uppercased() == section }.first
            let showIndex = collectionViewModel!.shows.index(of: firstShow!)
            
            indexPath = IndexPath(item: Int(showIndex!), section: 0)
        }
        
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: false)
    }
    
    // MARK: SickbeardListener
    
    func sickbeardShowCacheUpdated() {
        reloadShows()
        collectionView?.reloadData()
    }
    
    public func sickbeardShowAdded(_ show: SickbeardShow) {
        if let showIndex = collectionViewModel!.shows.index(of: show) {
            collectionView?.selectItem(at: IndexPath(item: showIndex, section: 0), animated: false, scrollPosition: .centeredVertically)
        }
    }
    
    // MARK: Show delete
    
    func longPressHandler() {
        guard let touch = longPressRecognizer?.location(in: collectionView),
            let indexPath = collectionView?.indexPathForItem(at: touch) else {
                return
        }
        
        let show = collectionViewModel!.shows[indexPath.item]
        showDeleteActionSheet(show)
    }
    
    func showDeleteActionSheet(_ show: SickbeardShow) {
        let actionSheet = UIAlertController(title: "Do you want to delete '\(show.name)'?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Yes, delete it!", style: .destructive, handler: { _ in
            SickbeardService.shared.deleteShow(show) { _ in } // Meh
        })
        actionSheet.addAction(deleteAction)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
}

extension SickbeardShowsViewController { // UISearchBarDelegate
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterShows(searchText.trimmed)
        
        super.searchBar(searchBar, textDidChange: searchText)
    }
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadAllShows()
        
        super.searchBarCancelButtonClicked(searchBar)
    }
    
}

extension SickbeardShow {
    
    var nameWithoutPrefix: String {
        let prefixes = ["The ", "A "]
        
        var showName = name
        prefixes.forEach { prefix in
            if showName.hasPrefix(prefix) {
                showName = showName.substring(0..<prefix.length)
            }
        }
        
        return showName
    }
    
}
