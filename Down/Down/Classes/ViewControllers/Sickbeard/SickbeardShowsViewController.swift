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

class SickbeardShowsViewController: DownDetailViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, DownSectionIndexViewDelegate {
    
    var dataSource: ShowsCollectionViewDataSource?
    
    @IBOutlet weak var sectionIndexView: DownSectionIndexView!
    
    let SymbolSectionTitle = "#"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shows"
        
        guard let collectionView = collectionView else {
            return
        }
        
        addSearchBar()
        
        let cellNib = UINib(nibName: "SickbeardShowCell", bundle:nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "SickbeardShowCell")
        collectionView.backgroundColor = .downLightGrayColor()
        
        dataSource = ShowsCollectionViewDataSource(collectionView)
        collectionView.dataSource = dataSource!
        
        loadShows()
        
        sectionIndexView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dataSource!.preheatController.enabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // When you disable preheat controller it removes all preheating
        // index paths and calls its handler
        dataSource!.preheatController.enabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView!.indexPathsForSelectedItems?.first , segue.identifier == "SickbeardShow" {
            let show = dataSource?.shows[indexPath.item]
            
            let detailViewController = segue.destination as! SickbeardShowViewController
            detailViewController.show = show
        }
    }
    
    func loadShows() {
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
        
        dataSource!.shows = Array(allShows).sorted(by: { $0.nameWithoutPrefix.uppercased() < $1.nameWithoutPrefix.uppercased() })
        sectionIndexView.datasource = sectionTitles
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let showsPerLine = 3
        // Calculate the widt
        var cellWidth = collectionView.bounds.width / CGFloat(showsPerLine)
        
        let modulus = (indexPath as NSIndexPath).row % showsPerLine
        if modulus == 0 {
            // Floor the outer left column
            cellWidth = floor(cellWidth)
        }
        else if modulus == showsPerLine - 1 {
            // Ceil the outer right column
            cellWidth = ceil(cellWidth)
        }
        
        // Calculate the height, aspect ration 66:100
        let cellHeight = (cellWidth / 66 * 100)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return searchBar?.bounds.size ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SickbeardShow", sender: nil)
    }
    
    // MARK: SectionIndexView
    
    func sectionIndexView(_ sectionIndexView: DownSectionIndexView, didSelectSection section: String, atIndex index: Int) {
        var indexPath = IndexPath(item: 0, section: 0)
        if (section != SymbolSectionTitle) {
            // Find first show with selected section title as first character
            let firstShow = dataSource!.shows.filter { $0.nameWithoutPrefix.substring(0..<1) == section }.first
            let showIndex = dataSource!.shows.index(of: firstShow!)
            
            indexPath = IndexPath(item: Int(showIndex!), section: 0)
        }
        
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: false)
    }
    
}

extension SickbeardShowsViewController { // UISearchBarDelegate
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmedText = searchText.trimmed
        
        var foundShows = DownDatabase.shared.fetchAllSickbeardShows()
        if trimmedText.length > 0 {
            foundShows = foundShows.filter("_simpleName contains[c] %@", trimmedText)
        }
        dataSource!.shows = Array(foundShows)
        
        super.searchBar(searchBar, textDidChange: searchText)
    }
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadShows()
        
        super.searchBarCancelButtonClicked(searchBar)
    }
    
}

extension UISearchBar {
    
    var textfield: UITextField? {
        get {
            return value(forKey: "searchField") as? UITextField
        }
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
