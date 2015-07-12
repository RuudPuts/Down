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
        super.init()
        
        self.title = title
        self.image = image
        self.tintColor = tintColor
    }
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
