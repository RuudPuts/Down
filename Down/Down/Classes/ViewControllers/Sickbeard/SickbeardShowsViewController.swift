//
//  SickbeardShowsViewController.swift
//  Down
//
//  Created by Ruud Puts on 19/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import Preheat
import Nuke
import RealmSwift

class SickbeardShowsViewController: DownDetailViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DownSectionIndexViewDelegate {
    
    let preheater = Preheater()
    var preheatController: Controller<UICollectionView>!
    var shows = [SickbeardShow]()
    
    @IBOutlet weak var sectionIndexView: DownSectionIndexView!
    
    let SymbolSectionTitle = "#"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shows"
        loadShows()
        
        sectionIndexView.delegate = self
        
        addSearchBar()
        
        let cellNib = UINib(nibName: "SickbeardShowCell", bundle:nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "SickbeardShowCell")
        collectionView?.backgroundColor = .downLightGrayColor()

        preheatController = Controller(view: collectionView!)
        preheatController.handler = { [weak self] in
            self?.preheatWindowChanged(addedIndexPaths: $0, removedIndexPaths: $1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        preheatController.enabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // When you disable preheat controller it removes all preheating
        // index paths and calls its handler
        preheatController.enabled = false
    }
    
    func preheatWindowChanged(addedIndexPaths added: [IndexPath], removedIndexPaths removed: [IndexPath]) {
        func requestsForIndexPaths(_ indexPaths: [IndexPath]) -> [Request] {
            var requests = [Request]()
            indexPaths.forEach {
                if $0.item < shows.count {
                    let request = shows[$0.item].posterThumbnailRequest
                    requests.append(request)
                }
            }
            
            return requests
        }
        preheater.startPreheating(with: requestsForIndexPaths(added))
        preheater.stopPreheating(with: requestsForIndexPaths(removed))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView!.indexPathsForSelectedItems?.first , segue.identifier == "SickbeardShow" {
            let show = shows[indexPath.item]
            
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
        
        shows = Array(allShows).sorted(by: { $0.nameWithoutPrefix.uppercased() < $1.nameWithoutPrefix.uppercased() })
        sectionIndexView.datasource = sectionTitles
    }
    
    // MARK: - CollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, isSectionEmtpy section: Int) -> Bool {
        return shows.count == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let show = shows[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SickbeardShowCell", for: indexPath) as! SickbeardShowCell
        cell.setCellType(.Sickbeard)
        cell.show = show
        
        Nuke.loadImage(with: show.posterThumbnailRequest, into: cell.posterView)
        
        return cell
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
            let firstShow = shows.filter { $0.nameWithoutPrefix.substring(0..<1) == section }.first
            let showIndex = shows.index(of: firstShow!)
            
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
        self.shows = Array(foundShows)
        
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
    
    var posterThumbnailRequest: Request {
        get {
            let filePath = UIApplication.documentsDirectory + "/sickbeard/posters/\(tvdbId)_thumb.png"
            return Request(url: URL(fileURLWithPath: filePath))
        }
    }
    
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
