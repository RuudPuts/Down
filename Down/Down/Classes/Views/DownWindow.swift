//
//  DownWindow.swift
//  Down
//
//  Created by Ruud Puts on 12/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownWindow : UIWindow {
    
    private var statusBarBackgroundLayer: CALayer?
    private var statusBarColor = UIColor.clearColor()
    
    override func makeKeyAndVisible() {
        super.makeKeyAndVisible()
        addStatusBarBackground()
    }
    
    private func addStatusBarBackground() {
        statusBarBackgroundLayer = CALayer()
        statusBarBackgroundLayer!.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 20)
        statusBarBackgroundLayer!.backgroundColor = statusBarColor.CGColor
        layer.addSublayer(statusBarBackgroundLayer!)
    }
    
    var statusBarBackgroundColor: UIColor! {
        get {
            return statusBarColor
        }
        set {
            statusBarColor = newValue
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            statusBarBackgroundLayer?.backgroundColor = newValue.CGColor
            CATransaction.commit()
        }
    }
    
}