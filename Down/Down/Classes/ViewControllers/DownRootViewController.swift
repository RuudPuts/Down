//
//  DownRootViewController.swift
//  Down
//
//  Created by Ruud Puts on 03/07/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownRootViewController: DownViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNavigationBar(animated)
    }
    
    // MARK: Navigation bar
    
    func showNavigationBar(_ animated: Bool) {
        guard self.navigationController?.viewControllers.count == 2 else {
            return
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func hideNavigationBar(_ animated: Bool) {
        guard self.navigationController?.viewControllers.count == 1 else {
            return
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension UINavigationController {
    
    func setupForApplication(_ application: DownApplication) {
        let color: UIColor
        
        switch application {
        case .SabNZBd:
            color = .downSabNZBdColor()
            break
        case .Sickbeard:
            color = .downSickbeardColor()
            break
        case .CouchPotato:
            color = .downCouchPotatoColor()
            break
        case .Down:
            color = .downRedColor()
            break
            
        }
        
        navigationBar.barTintColor = color
        navigationBar.backgroundColor = color
    }
    
}

extension UINavigationController: DownTabBarItem {
    
    var tabIcon: UIImage {
        get {
            if let viewController = viewControllers.first as? DownTabBarItem {
                return viewController.tabIcon
            }
            
            return UIImage()
        }
    }
    
    var selectedTabBackground: UIColor {
        get {
            if let viewController = viewControllers.first as? DownTabBarItem {
                return viewController.selectedTabBackground
            }
            
            return UIColor.clear
        }
    }
    
    var deselectedTabBackground: UIColor {
        get {
            if let viewController = viewControllers.first as? DownTabBarItem {
                return viewController.deselectedTabBackground
            }
            
            return UIColor.clear
        }
    }    
}
