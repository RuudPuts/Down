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
    
    lazy var overlay = DownOverlay.overlay()
    
    var application = DownApplication.Down
    
    var serviceManager: ServiceManager {
        get {
            return UIApplication.shared.downAppDelegate.serviceManager
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.backgroundColor = .downDarkGrayColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !scrollViewAdjusted {
            adjustScrollView(false)
            scrollViewAdjusted = true
        }
    }
    
    func adjustScrollView(_ animated: Bool) {
        guard let scrollView = scrollView, let searchBar = searchBar else {
            return
        }
        
        searchBar.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: searchBar.bounds.height)
        scrollView.setContentOffset(CGPoint(x: 0, y: searchBar.bounds.height),
                                    animated: animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            guard let scrollView = self.scrollView, let searchBar = self.searchBar else {
                return
            }
            
            searchBar.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: searchBar.bounds.height)
        }, completion: nil)
    }
}

extension DownViewController: UISearchBarDelegate {
    
    func addSearchBar() {
        guard scrollView != nil else {
            return
        }
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.textfield?.textColor = .lightGray
        
        searchBar.sizeToFit()
        self.searchBar = searchBar
        
        collectionView?.addSubview(searchBar)
        tableView?.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView?.reloadData()
        tableView?.reloadData()
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        collectionView?.reloadData()
        tableView?.reloadData()
        adjustScrollView(true)
    }
}

extension UISearchBar {
    
    var textfield: UITextField? {
        get {
            return value(forKey: "searchField") as? UITextField
        }
    }
    
}

extension DownViewController { // Overlay
    
    func showOverlay() {
        guard let window = UIApplication.shared.downAppDelegate.window else {
            return
        }
        
        overlay.frame = window.bounds
        if overlay.superview != self {
            overlay.frame = window.bounds
            window.addSubview(overlay)
        }
        
        overlay.show()
    }
    
    func hideOverlay() {
        overlay.hide()
    }
}
