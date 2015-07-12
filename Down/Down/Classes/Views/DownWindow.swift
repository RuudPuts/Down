//
//  DownWindow.swift
//  Down
//
//  Created by Ruud Puts on 12/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

class DownWindow : UIWindow {
    
    private var statusBarBackgroundLayer: CALayer?
    
    override func makeKeyAndVisible() {
        super.makeKeyAndVisible()
        addStatusBarBackground()
    }
    
    private func addStatusBarBackground() {
        statusBarBackgroundLayer = CALayer()
        statusBarBackgroundLayer!.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 20)
        statusBarBackgroundLayer!.backgroundColor = UIColor.clearColor().CGColor
        layer.addSublayer(statusBarBackgroundLayer!)
    }
    
    var statusBarBackgroundColor: UIColor! {
        get {
            return UIColor(CGColor: statusBarBackgroundLayer!.backgroundColor!)
        }
        set {
            statusBarBackgroundLayer!.backgroundColor = newValue.CGColor
        }
    }
    
}