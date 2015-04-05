//
//  ViewController.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let serviceManager: ServiceManager!

    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        serviceManager = appDelegate.serviceManager
        
        self.edgesForExtendedLayout = .None
    }
    
    convenience required init(coder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }

}

