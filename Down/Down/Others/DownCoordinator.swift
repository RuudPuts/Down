//
//  DownCoordinator.swift
//  Down
//
//  Created by Ruud Puts on 12/03/17.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import DownKit

class DownCoordinator {
    
    class func deeplink(_ userActivity: NSUserActivity) -> Bool {
        guard let identifier = userActivity.userInfo?["kCSSearchableItemActivityIdentifier"] as? String else {
            return false
        }
        
        if identifier.hasPrefix("com.ruudputs.down.show") {
            guard let idString = identifier.components(separatedBy: ".").last, let showId = Int(idString) else {
                return false
            }
            
            if let show = SickbeardService.shared.showWithId(showId) {
                deeplinkShowDetails(show)
            }
        }
        
        return false
    }
    
    // MARK: Properties
    
    class var tabBarController: DownTabBarViewController? {
        return UIApplication.shared.downAppDelegate.window?.rootViewController as? DownTabBarViewController

    }
    
    class var sickbeardNavigationController: UINavigationController? {
        return tabBarController?.viewControllers[1] as? UINavigationController
    }
    
    class var sabNZBdStoryboard: UIStoryboard {
        return UIStoryboard(name: "SabNZBd", bundle: Bundle.main)
    }
    
    class var sickbeardStoryboard: UIStoryboard {
        return UIStoryboard(name: "Sickbeard", bundle: Bundle.main)
    }
    
    class var couchPotatoStoryboard: UIStoryboard {
        return UIStoryboard(name: "CouchPotato", bundle: Bundle.main)
    }
    
    // MARK: Functions
    
    class func deeplinkShowDetails(_ show: SickbeardShow) {
        guard let navigationController = sickbeardNavigationController, let tabBarController = tabBarController else {
            return
        }
        
        let sickbeardViewController = navigationController.viewControllers.first!
        let showsViewController = sickbeardStoryboard.instantiateViewController(withIdentifier: "SickbeardShows") as! SickbeardShowsViewController
        let showDetailViewController = sickbeardStoryboard.instantiateViewController(withIdentifier: "SickbeardShowDetails") as! SickbeardShowViewController
        showDetailViewController.show = show
        
        navigationController.viewControllers = [sickbeardViewController, showsViewController, showDetailViewController]
        navigationController.setNavigationBarHidden(false, animated: false)
        tabBarController.selectViewController(navigationController)
    }

}
