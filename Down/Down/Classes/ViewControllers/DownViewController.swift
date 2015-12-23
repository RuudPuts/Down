//
//  DownViewController.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownViewController: UIViewController {
    
    let serviceManager: ServiceManager!
    var window: DownWindow {
        return UIApplication.sharedApplication().downAppDelegate.downWindow
    }

    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        serviceManager = appDelegate.serviceManager
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.edgesForExtendedLayout = .None
    }
    
    convenience required init(coder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }
}