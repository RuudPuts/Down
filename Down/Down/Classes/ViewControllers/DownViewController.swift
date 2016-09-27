//
//  DownViewController.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var collectionView: UICollectionView?
    var scrollView: UIScrollView? {
        get {
            return tableView ?? collectionView
        }
    }
    
    var searchBar: UISearchBar?
    var scrollViewAdjusted = false
    
    var serviceManager: ServiceManager {
        get {
            return UIApplication.sharedApplication().downAppDelegate.serviceManager
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        self.view.backgroundColor = .downDarkGrayColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !scrollViewAdjusted {
            adjustScrollView(false)
            scrollViewAdjusted = true
        }
    }
    
    func adjustScrollView(animated: Bool) {
        guard let scrollView = scrollView, let searchBar = searchBar else {
            return
        }
        
        searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), CGRectGetHeight(searchBar.bounds))
        scrollView.setContentOffset(CGPointMake(0, CGRectGetHeight(searchBar.bounds)),
                                    animated: animated)
    }
}

extension DownViewController: UISearchBarDelegate {
    
    func addSearchBar() {
        guard let targetView = scrollView else {
            return
        }
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .Minimal
        searchBar.textfield?.textColor = .lightGrayColor()
        
        searchBar.sizeToFit()
        self.searchBar = searchBar
        
        targetView.addSubview(searchBar)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView?.reloadData()
        tableView?.reloadData()
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        
        collectionView?.reloadData()
        tableView?.reloadData()
        adjustScrollView(true)
    }
}