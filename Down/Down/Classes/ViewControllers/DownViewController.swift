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
    
    var window: DownWindow {
        return UIApplication.sharedApplication().downAppDelegate.downWindow
    }
    
    var serviceManager: ServiceManager {
        get {
            return UIApplication.sharedApplication().downAppDelegate.serviceManager
        }
    }
    
    var sabNZBdService: SabNZBdService {
        get {
            return serviceManager.sabNZBdService
        }
    }
    var sickbeardService: SickbeardService {
        get {
            return serviceManager.sickbeardService
        }
    }

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
    }
}