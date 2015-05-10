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
        
        if self.selectedViewController == nil {
            selectViewController(self.viewControllers?.first)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for subview in self.contentView.subviews as! [UIView] {
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
            
            for viewController: UIViewController in _viewControllers! {
                self.addChildViewController(viewController)
            }
            
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: CollectionView datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _viewControllers?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(cellIdentifier, indexPath: indexPath) as! DownTabBarItemCell
        
        let viewController: UIViewController = _viewControllers![indexPath.row]
        cell.tabBarItem = viewController.tabBarItem as! DownTabBarItem!
        
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
        if let selectedViewController = viewController {
            if self.selectedViewController == selectedViewController {
                if self.selectedViewController is UINavigationController {
                    let navigationController = self.selectedViewController as! UINavigationController
                    navigationController.popToRootViewControllerAnimated(true)
                }
            }
            else {
                self.contentView.removeAllSubViews()
                self.selectedViewController = selectedViewController
                let tabBarItem = selectedViewController.tabBarItem as! DownTabBarItem!
                self.collectionView!.backgroundColor = tabBarItem.tintColor
                
                selectedViewController.view.frame = self.view.bounds
                self.contentView!.addSubview(selectedViewController.view)
            }
        }
        else {
            self.contentView.removeAllSubViews()
            self.collectionView.backgroundColor = UIColor.whiteColor()
        }
    }
    
}
