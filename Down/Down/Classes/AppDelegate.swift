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
        sabNZBdViewController.tabBarItem = DownTabBarItem(title: "SabNZBd", image: UIImage(named: "sabnzbd-tabbar"), tintColor: UIColor.downSabNZBdColor())

        let sickbeardViewController = SickbeardViewController()
        sickbeardViewController.tabBarItem = DownTabBarItem(title: "Sickbeard", image: UIImage(named: "sickbeard-tabbar"), tintColor: UIColor.downSickbeardDarkColor())
        
        let couchPotatoViewController = CouchPotatoViewController()
        couchPotatoViewController.tabBarItem = DownTabBarItem(title: "CouchPotato", image: UIImage(named: "couchpotato-tabbar"), tintColor: UIColor.downCouchPotatoColor())

        let tabBarController = DownTabBarController()
        tabBarController.viewControllers = [sabNZBdViewController, sickbeardViewController, couchPotatoViewController]
        
        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
    }
    
}

