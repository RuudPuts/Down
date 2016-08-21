//
//  CouchPotatoViewController.swift
//  Down
//
//  Created by Ruud Puts on 05/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class CouchPotatoViewController: DownRootViewController {

    convenience init() {
        self.init(nibName: "CouchPotatoViewController", bundle: nil)
    }
    
}

extension CouchPotatoViewController: DownTabBarItem {
    
    var tabIcon: UIImage {
        get {
            return UIImage(named: "couchpotato-tabbar")!
        }
    }
    
    var selectedTabBackground: UIColor {
        get {
            return .downCouchPotatoColor()
        }
    }
    
    var deselectedTabBackground: UIColor {
        get {
            return .downCouchPotatoDarkColor()
        }
    }
}
