//
//  DownTabBarViewController.swift
//  Down
//
//  Created by Ruud Puts on 07/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownTabBarViewController: DownViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var tabButtons: [UIButton]!

    var selectedViewController: UIViewController?
    var viewControllers = [UIViewController]() {
        didSet {
            updateChildViewControllers()
        }
    }
    
    var selectedTabBarItem: DownTabBarItem? {
        get {
            return selectedViewController as? DownTabBarItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarCellNib = UINib(nibName: "DownTabBarCell", bundle: nil)
        collectionView!.registerNib(tabBarCellNib, forCellWithReuseIdentifier: "DownTabBarCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let firstTabItem = viewControllers.first, selectedViewController == nil {
            selectViewController(firstTabItem)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutContentView()
    }
    
    func updateChildViewControllers() {
        childViewControllers.forEach { $0.removeFromParentViewController() }
        viewControllers.forEach { addChildViewController($0) }
    }
    
    func layoutContentView() {
        for subview in contentView.subviews {
            subview.frame = contentView.bounds
        }
    }
    
    func selectViewController(viewController: UIViewController) {
        if viewController == selectedViewController {
            // Selected tab repressed, pop navigation controller to root
            if let navigationController = selectedViewController as? UINavigationController {
                navigationController.popToRootViewControllerAnimated(true)
            }
        }
        else {
            // New tab selected, update the content view
            for view in contentView.subviews as [UIView] {
                view.removeFromSuperview()
            }
            
            selectedViewController = viewController
            contentView.addSubview(viewController.view)
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            // Add constraints to new view
            let views = ["view": viewController.view]
            let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: .AlignAllTop, metrics: nil, views: views)
            contentView.addConstraints(horizontalConstraint)
            
            let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: .AlignAllTop, metrics: nil, views: views)
            contentView.addConstraints(verticalConstraint)
            
            // Layout the view
            contentView.layoutIfNeeded()
            
            // Inform the view controller shit went down (get it? Down... I'll see myself out)
            viewController.didMoveToParentViewController(self)
        }
    }
    
    // MARK: CollectionView datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell("DownTabBarCell", indexPath: indexPath) as! DownTabBarCell
        
        let viewController = viewControllers[indexPath.row]
        
        if let tabBarItem = viewController as? DownTabBarItem {
            cell.imageView.image = tabBarItem.tabIcon
            
            if viewController == selectedViewController {
                cell.backgroundColor = selectedTabBarItem?.selectedTabBackground
            }
            else {
                cell.backgroundColor = selectedTabBarItem?.deselectedTabBackground
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tabCount = Float(viewControllers.count)
        let width = Float(CGRectGetWidth(view.bounds)) / tabCount
        
        return CGSizeMake(CGFloat(width), CGRectGetHeight(collectionView.bounds))
    }
    
    // MARK: CollectionView delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectViewController(viewControllers[indexPath.row])
        collectionView.reloadData()
    }
}

protocol DownTabBarItem {
    
    var selectedTabBackground: UIColor { get }
    var deselectedTabBackground: UIColor { get }
    var tabIcon: UIImage { get }
    
}
