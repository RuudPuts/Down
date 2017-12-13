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
        return selectedViewController as? DownTabBarItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarCellNib = UINib(nibName: "DownTabBarCell", bundle: nil)
        collectionView!.register(tabBarCellNib, forCellWithReuseIdentifier: "DownTabBarCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func selectViewController(_ viewController: UIViewController) {
        if viewController == selectedViewController {
            // Selected tab repressed, pop navigation controller to root
            if let navigationController = selectedViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: true)
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
            let views: [String: UIView] = ["view": viewController.view] // http://stackoverflow.com/a/39520582
            let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .alignAllTop, metrics: nil, views: views)
            contentView.addConstraints(horizontalConstraint)
            
            let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .alignAllTop, metrics: nil, views: views)
            contentView.addConstraints(verticalConstraint)
            
            // Layout the view
            contentView.layoutIfNeeded()
            
            // Inform the view controller shit went down (get it? Down... I'll see myself out)
            viewController.didMove(toParentViewController: self)
            
            collectionView?.reloadData()
        }
    }
    
    // MARK: CollectionView datasource
    
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell("DownTabBarCell", indexPath: indexPath) as! DownTabBarCell
        
        let viewController = viewControllers[(indexPath as NSIndexPath).row]
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let tabCount = Float(viewControllers.count)
        var width = Float(view.bounds.width) / tabCount
        width = indexPath.item % 2 == 0 ? floor(width) : ceil(width)
        
        return CGSize(width: CGFloat(width), height: collectionView.bounds.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView?.reloadData()
        }, completion: nil)
    }
    
    // MARK: CollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        selectViewController(viewControllers[(indexPath as NSIndexPath).row])
        collectionView.reloadData()
    }
}

protocol DownTabBarItem {
    
    var selectedTabBackground: UIColor { get }
    var deselectedTabBackground: UIColor { get }
    var tabIcon: UIImage { get }
    
}
