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
        
        
        
        for view in tabBarController.contentView.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        // Add view to placeholder view
        tabBarController.currentViewController = destinationController
        tabBarController.contentView.addSubview(destinationController.view)
        
        // Set autoresizing
        tabBarController.contentView.translatesAutoresizingMaskIntoConstraints = false
        destinationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.contentView.addConstraints(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.contentView.addConstraints(verticalConstraint)
        
        tabBarController.contentView.layoutIfNeeded()
        destinationController.didMoveToParentViewController(tabBarController)
        
    }
    
}
