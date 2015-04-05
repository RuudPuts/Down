//
//  DownTabBarItem.swift
//  Down
//
//  Created by Ruud Puts on 05/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownTabBar: UITabBar {
   
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        CGContextFillRect(context, rect)
    }
    
}
