//
//  DownTabBarItemCell.swift
//  Down
//
//  Created by Ruud Puts on 07/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownTabBarItemCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    private var _tabBarItem: DownTabBarItem?
    var tabBarItem: DownTabBarItem? {
        get {
            return _tabBarItem
        }
        set {
            _tabBarItem = newValue
            
            self.tintColor = _tabBarItem?.tintColor ?? UIColor.clearColor()
            self.imageView.image = _tabBarItem?.image
        }
    }
}
