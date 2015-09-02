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
    var selectedTabIndex: Int!
    
    private var _viewControllers: [UIViewController]?
    
    private var cellIdentifier = "DownTabBarItemCell"
    
    convenience init() {
        self.init(nibName: "DownTabBarController", bundle: nil)
        
        selectedTabIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarCellNib = UINib(nibName: "DownTabBarItemCell", bundle: nil)
        self.collectionView.registerNib(tabBarCellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.selectedViewController == nil {
            selectViewController(viewControllers?.first)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for subview in self.contentView.subviews as [UIView] {
            subview.frame = contentView.bounds
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
                addChildViewController(viewController)
            }
            
            collectionView?.reloadData()
        }
    }
    
    var selectedTabColor: UIColor {
        let color: UIColor
        
        switch selectedTabIndex {
        case 0:
            color = .downSabNZBdDarkColor()
            break
        case 1:
            color = .downSickbeardDarkColor()
            break
        case 2:
            color = .downCouchPotatoDarkColor()
            break
        default:
            color = .blackColor()
            break
        }
        
        return color
    }
    
    var deselectedTabColor: UIColor {
        let color: UIColor
        
        switch selectedTabIndex {
        case 0:
            color = .downSabNZBdColor()
            break
        case 1:
            color = .downSickbeardColor()
            break
        case 2:
            color = .downCouchPotatoColor()
            break
        default:
            color = .blackColor()
            break
        }
        
        return color
    }
    
    // MARK: CollectionView datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _viewControllers?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellIdentifier, indexPath: indexPath) as! DownTabBarItemCell
        
        let viewController: UIViewController = _viewControllers![indexPath.row]
        cell.tabBarItem = viewController.tabBarItem as! DownTabBarItem!
        
        if indexPath.item == selectedTabIndex {
            cell.backgroundColor = selectedTabColor
        }
        else {
            cell.backgroundColor = deselectedTabColor
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfCells = Float(self.collectionView(collectionView, numberOfItemsInSection: indexPath.section))
        let width = Float(CGRectGetWidth(self.view.bounds)) / numberOfCells
        
        return CGSizeMake(CGFloat(width), CGRectGetHeight(collectionView.bounds))
    }
    
    // MARK: CollectionView delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedTabIndex = indexPath.item
        selectViewController(_viewControllers![selectedTabIndex])
        collectionView.reloadData()
    }

    // MARK: Private methods
    
    private func selectViewController(viewController: UIViewController?) {
        if let selectedViewController = viewController {
            if self.selectedViewController == selectedViewController {
                if selectedViewController is UINavigationController {
                    let navigationController = selectedViewController as! UINavigationController
                    navigationController.popToRootViewControllerAnimated(true)
                }
            }
            else {
                contentView.removeAllSubViews()
                applyAppearance()
                
                let tabBarItem = selectedViewController.tabBarItem as! DownTabBarItem!
                collectionView!.backgroundColor = tabBarItem.tintColor
                
                selectedViewController.view.frame = self.view.bounds
                contentView!.addSubview(selectedViewController.view)
                self.selectedViewController = selectedViewController
            }
        }
        else {
            contentView.removeAllSubViews()
            collectionView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.reloadData()
    }
    
    private func applyAppearance() {
        UINavigationBar.appearance().barStyle = .Default
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.downLightGreyColor()]
        UINavigationBar.appearance().tintColor = UIColor.downDarkGreyColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.downDarkGreyColor()], forState: .Normal)
        
        let downWindow = (UIApplication.sharedApplication().delegate as! AppDelegate).window as! DownWindow
        
        switch selectedTabIndex {
        case 0:
            UINavigationBar.appearance().barTintColor = UIColor.downSabNZBdColor()
            downWindow.statusBarBackgroundColor = UIColor.downSabNZBdDarkColor()
            break
        case 1:
            UINavigationBar.appearance().barTintColor = UIColor.downSickbeardColor()
            downWindow.statusBarBackgroundColor = UIColor.downSickbeardDarkColor()
            break
        case 2:
            UINavigationBar.appearance().barTintColor = UIColor.downCouchPotatoColor()
            downWindow.statusBarBackgroundColor = UIColor.downCouchPotatoDarkColor()
            break
        default:
            break
        }
    }
    
}
