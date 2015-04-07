//
//  DownTabBarItem.swift
//  Down
//
//  Created by Ruud Puts on 07/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownTabBarItem: UITabBarItem {
    
    var tintColor: UIColor?

    init(title: String?, image: UIImage?, tintColor: UIColor?) {
        super.init(title: title, image: image, tag: 0)
        
        self.tintColor = tintColor
    }
    
    override init() {
        super.init()
    }
    
}
