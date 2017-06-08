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
        let sabNZBdSetup = Preferences.sabNZBdHost == nil || (Preferences.sabNZBdHost!.length > 0 && Preferences.sabNZBdApiKey.length > 0)
        let sickbeardSetup = Preferences.sickbeardHost.length > 0 && Preferences.sickbeardApiKey.length > 0
        
        return sabNZBdSetup && sickbeardSetup
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        checkClearCache()
        serviceManager = ServiceManager()

        setupAppearance()
        setupTabBarController()
        setupOnboarding()
        
        return true
    }
    
    func setupAppearance() {
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.downLightGrayColor()]
        UINavigationBar.appearance().tintColor = UIColor.downDarkGrayColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.downDarkGrayColor()], for: UIControlState())
        
        let cancelButtonAttributes = [NSForegroundColorAttributeName: UIColor(red:0.51, green:0.51, blue:0.53, alpha:1.00),
                                      NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: UIControlState())
    }
    
    func checkRefreshSickbeardCache() {
        guard Preferences.downRefreshSickbeardCache else {
            return
        }
        
        SickbeardService.shared.refreshShowCache(force: true)
        Preferences.downRefreshSickbeardCache = false
    }
    
    func checkClearCache() {
        guard Preferences.downClearCache else {
            return
        }
        
        ImageProvider.clearCache()
        DownDatabase.clearCache()
        Preferences.clearCache()
    }
    
    func setupTabBarController() {
        let sabNZBdController = DownCoordinator.sabNZBdStoryboard.instantiateInitialViewController()!
        (sabNZBdController as! UINavigationController).setupForApplication(.SabNZBd)
        
        let sickbeardController = DownCoordinator.sickbeardStoryboard.instantiateInitialViewController()!
        (sickbeardController as! UINavigationController).setupForApplication(.Sickbeard)
        
        let couchPotatoController = DownCoordinator.couchPotatoStoryboard.instantiateInitialViewController()!
        (couchPotatoController as! UINavigationController).setupForApplication(.CouchPotato)
        
        let tabBarController = window?.rootViewController as! DownTabBarViewController
        tabBarController.viewControllers = [sabNZBdController, sickbeardController, couchPotatoController]
    }
    
    func setupOnboarding() {
        // Check if intro should be shown
        if !isSetup {
            let introViewController = DownIntroViewController(introType: .welcome)
            let introNavigationController = UINavigationController(rootViewController: introViewController)
            introNavigationController.isNavigationBarHidden = true
            
            // Trigger window showing automatically
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(introNavigationController, animated: false, completion: nil)
        }
        else {
            serviceManager.startAllServices()
            
            checkRefreshSickbeardCache()
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return DownCoordinator.deeplink(userActivity)
    }
}

extension UIApplication {
    var downAppDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
