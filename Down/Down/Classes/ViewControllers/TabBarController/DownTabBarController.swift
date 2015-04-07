//
//  TabBarController.swift
//  Down
//
//  Created by Ruud Puts on 07/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownTabBarController: ViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedViewController: UIViewController?
    
    private var _viewControllers: [UIViewController]?
    
    private var cellIdentifier = "DownTabBarItemCell"
    
    convenience init() {
        self.init(nibName: "DownTabBarController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarCellNib = UINib(nibName: "DownTabBarItemCell", bundle: nil)
        self.collectionView.registerNib(tabBarCellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.selectedViewController == nil) {
            selectViewController(self.viewControllers?.first)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for subview: UIView in self.contentView.subviews as [UIView] {
            subview.frame = self.contentView.bounds
        }
    }
    
    // MARK: Setters and getters
    
    var viewControllers: [UIViewController]? {
        get {
            return _viewControllers
        }
        set {
            _viewControllers = newValue
            
            if (_viewControllers != nil) {
                for viewController: UIViewController in _viewControllers! {
                    self.addChildViewController(viewController)
                }
            }
            
            if (self.collectionView != nil) {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: CollectionView datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if (_viewControllers != nil) {
            numberOfRows = _viewControllers!.count
        }
        
        return numberOfRows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(cellIdentifier: cellIdentifier, indexPath: indexPath) as DownTabBarItemCell
        
        let viewController: UIViewController = _viewControllers![indexPath.row]
        cell.tabBarItem = viewController.tabBarItem as DownTabBarItem!
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var numberOfCells = Float(self.collectionView(collectionView, numberOfItemsInSection: indexPath.section))
        var width = Float(CGRectGetWidth(self.view.bounds)) / numberOfCells
        
        return CGSizeMake(CGFloat(width), CGRectGetHeight(collectionView.bounds))
    }
    
    // MARK: CollectionView delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectViewController(_viewControllers![indexPath.row])
    }

    // MARK: Private methods
    
    private func selectViewController(viewController: UIViewController?) {
        self.contentView.removeAllSubViews()
        if (viewController != nil) {
            self.selectedViewController = viewController!
            let tabBarItem = viewController!.tabBarItem as DownTabBarItem!
            self.collectionView!.backgroundColor = tabBarItem.tintColor
            
            viewController!.view.frame = self.view.bounds
            self.contentView!.addSubview(viewController!.view)
        }
        else {
            self.collectionView.backgroundColor = UIColor.whiteColor()
        }
    }
    
}
