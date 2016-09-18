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
        
        checkClearCache()
        serviceManager = ServiceManager()

        setupAppearance()
        setupTabBarController()
        setupOnboarding()
        
        return true
    }
    
    func setupAppearance() {
        UINavigationBar.appearance().barStyle = .Default
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.downLightGrayColor()]
        UINavigationBar.appearance().tintColor = UIColor.downDarkGrayColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.downDarkGrayColor()], forState: .Normal)
        
        let cancelButtonAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, forState: .Normal)
    }
    
    func checkClearCache() {
        guard PreferenceManager.downClearCache else {
            return
        }
        
        ImageProvider.clearCache()
        DatabaseManager.clearCache()
        PreferenceManager.clearCache()
    }
    
    func setupTabBarController() {
        let sabNZBdController = UIStoryboard(name: "SabNZBd", bundle: NSBundle.mainBundle()).instantiateInitialViewController()!
        (sabNZBdController as! UINavigationController).setupForApplication(.SabNZBd)
        
        let sickbeardController = UIStoryboard(name: "Sickbeard", bundle: NSBundle.mainBundle()).instantiateInitialViewController()!
        (sickbeardController as! UINavigationController).setupForApplication(.Sickbeard)
        
        let couchPotatoController = UIStoryboard(name: "CouchPotato", bundle: NSBundle.mainBundle()).instantiateInitialViewController()!
        (couchPotatoController as! UINavigationController).setupForApplication(.CouchPotato)
        
        let tabBarController = window?.rootViewController as! DownTabBarViewController
        tabBarController.viewControllers = [sabNZBdController, sickbeardController, couchPotatoController]
    }
    
    func setupOnboarding() {
        // Check if intro should be shown
        if !isSetup {
            let introViewController = DownIntroViewController(introType: .Welcome)
            let introNavigationController = UINavigationController(rootViewController: introViewController)
            introNavigationController.navigationBarHidden = true
            
            // Trigger window showing automatically
            window?.makeKeyAndVisible()
            window?.rootViewController?.presentViewController(introNavigationController, animated: false, completion: nil)
        }
        else {
            serviceManager.startAllServices()
        }
    }
}

extension UIApplication {
    var downAppDelegate: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}