//
//  AppDelegate.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var serviceManager: ServiceManager!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        serviceManager = ServiceManager()
        
        initializeWindow()
        
        return true
    }
    
    func initializeWindow() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let sabNZBdViewController = SabNZBdViewController()
        sabNZBdViewController.tabBarItem = UITabBarItem(title: "SabNZBd", image: UIImage(named: "sabnzbd-tabbar"), tag: 0)

        let sickbeardViewController = SickbeardViewController()
        sickbeardViewController.tabBarItem = UITabBarItem(title: "Sickbeard", image: UIImage(named: "sickbeard-tabbar"), tag: 0)
        
        let couchPotatoViewController = CouchPotatoViewController()
        couchPotatoViewController.tabBarItem = UITabBarItem(title: "CouchPotato", image: UIImage(named: "couchpotato-tabbar"), tag: 0)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [sabNZBdViewController, sickbeardViewController, couchPotatoViewController]
        
        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
    }
    
}

