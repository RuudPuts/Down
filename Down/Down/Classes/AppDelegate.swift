//
//  AppDelegate.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import CoreData
import DownKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var serviceManager: ServiceManager!
    
    var isSetup: Bool {
        let sabNZBdSetup = PreferenceManager.sabNZBdHost.length > 0 && PreferenceManager.sabNZBdApiKey.length > 0
        let sickbeardSetup = PreferenceManager.sickbeardHost.length > 0 && PreferenceManager.sickbeardApiKey.length > 0
        
        return sabNZBdSetup && sickbeardSetup
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        serviceManager = ServiceManager()
//
//        initializeWindow()
        
        return true
    }
    
//    func initializeWindow() {
//        let downWindow = DownWindow(frame: UIScreen.mainScreen().bounds)
//
//        let sabNZBdViewController = SabNZBdViewController()
//        sabNZBdViewController.tabBarItem = DownTabBarItem(title: "SabNZBd", image: UIImage(named: "sabnzbd-tabbar"), tintColor: UIColor.downSabNZBdColor())
//        let sabNZBdNavigationController = UINavigationController(rootViewController: sabNZBdViewController)
//        sabNZBdNavigationController.navigationBarHidden = true
//
//        let sickbeardViewController = SickbeardViewController()
//        sickbeardViewController.tabBarItem = DownTabBarItem(title: "Sickbeard", image: UIImage(named: "sickbeard-tabbar"), tintColor: UIColor.downSickbeardDarkColor())
//        let sickbeardNavigationController = UINavigationController(rootViewController: sickbeardViewController)
//        sickbeardNavigationController.navigationBarHidden = true
//        
//        let couchPotatoViewController = CouchPotatoViewController()
//        couchPotatoViewController.tabBarItem = DownTabBarItem(title: "CouchPotato", image: UIImage(named: "couchpotato-tabbar"), tintColor: UIColor.downCouchPotatoColor())
//        let couchPotatoNavigationController = UINavigationController(rootViewController: couchPotatoViewController)
//        couchPotatoNavigationController.navigationBarHidden = true
//
//        let tabBarController = DownTabBarViewController()
//        tabBarController.viewControllers = [sabNZBdNavigationController, sickbeardNavigationController, couchPotatoNavigationController]
//        
//        downWindow.rootViewController = tabBarController
//        window = downWindow
//        downWindow.makeKeyAndVisible()
//        
//        // Check if intro should be shown
//        if !isSetup {
//            let introViewController = DownIntroViewController(introType: .Welcome)
//            let introNavigationController = UINavigationController(rootViewController: introViewController)
//            introNavigationController.navigationBarHidden = true
//            
//            downWindow.rootViewController!.presentViewController(introNavigationController, animated: false, completion: nil)
//        }
//        else {
//            serviceManager.startAllServices()
//        }
//    }
}

extension UIApplication {
    var downAppDelegate: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}

extension AppDelegate {
    var downWindow: DownWindow {
        return DownWindow() //self.window as! DownWindow
    }
}