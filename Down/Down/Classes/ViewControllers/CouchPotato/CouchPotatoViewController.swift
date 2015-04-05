//
//  CouchPotatoViewController.swift
//  Down
//
//  Created by Ruud Puts on 05/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class CouchPotatoViewController: ViewController {

    convenience init() {
        self.init(nibName: "CouchPotatoViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.barTintColor = UIColor.downCouchPotatoColor()
    }
    
}
