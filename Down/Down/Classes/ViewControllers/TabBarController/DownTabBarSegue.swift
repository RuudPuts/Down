//
//  DownTabBarSegue.swift
//  Down
//
//  Created by Ruud Puts on 20/08/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit

class DownTabBarSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let tabBarController = self.sourceViewController as! DownTabBarViewController
        let destinationController = self.destinationViewController
        let contentView = tabBarController.contentView
        
        if tabBarController.tabChanged || contentView.subviews.count == 0 {
            // New tab selected, update the content view
            let contentView = tabBarController.contentView
            
            for view in contentView.subviews as [UIView] {
                view.removeFromSuperview()
            }
            
            tabBarController.currentViewController = destinationController
            contentView.addSubview(destinationController.view)
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            destinationController.view.translatesAutoresizingMaskIntoConstraints = false
            
            // Add constraints to new view
            let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
            contentView.addConstraints(horizontalConstraint)
            
            let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
            contentView.addConstraints(verticalConstraint)
            
            // Layout the view
            contentView.layoutIfNeeded()
            
            // Inform the view controller shit went down (get it? Down... I'll see myself out)
            destinationController.didMoveToParentViewController(tabBarController)
        }
        else {
            // Selected tab repressed, pop navigation controller to root
            if tabBarController.currentViewController!.isKindOfClass(UINavigationController) {
                (tabBarController.currentViewController as! UINavigationController).popToRootViewControllerAnimated(true)
            }
        }
    }
    
}
