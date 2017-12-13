//
//  CouchPotatoViewController.swift
//  Down
//
//  Created by Ruud Puts on 05/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import Rswift

class CouchPotatoViewController: DownRootViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "CouchPotato"
    }
}

extension CouchPotatoViewController: DownTabBarItem {
    
    var tabIcon: UIImage {
        return R.image.couchpotatoTabbar()!
    }
    
    var selectedTabBackground: UIColor {
        return DownApplication.CouchPotato.color
    }
    
    var deselectedTabBackground: UIColor {
        return DownApplication.CouchPotato.darkColor
    }
}
