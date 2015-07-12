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

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [NSObject: AnyObject]?) -> Bool {
        Instabug.startWithToken("dc9091202562420874c069cfc74b57fd", captureSource: IBGCaptureSourceUIKit, invocationEvent: IBGInvocationEventShake)
        
        serviceManager = ServiceManager()
        initializeWindow()
        
        return true
    }
    
    func initializeWindow() {
        let downWindow = DownWindow(frame: UIScreen.mainScreen().bounds)

        let sabNZBdViewController = SabNZBdViewController()
        sabNZBdViewController.tabBarItem = DownTabBarItem(title: "SabNZBd", image: UIImage(named: "sabnzbd-tabbar"), tintColor: UIColor.downSabNZBdColor())
        let sabNZBdNavigationController = UINavigationController(rootViewController: sabNZBdViewController)
        sabNZBdNavigationController.navigationBarHidden = true

        let sickbeardViewController = SickbeardViewController()
        sickbeardViewController.tabBarItem = DownTabBarItem(title: "Sickbeard", image: UIImage(named: "sickbeard-tabbar"), tintColor: UIColor.downSickbeardDarkColor())
        
        let couchPotatoViewController = CouchPotatoViewController()
        couchPotatoViewController.tabBarItem = DownTabBarItem(title: "CouchPotato", image: UIImage(named: "couchpotato-tabbar"), tintColor: UIColor.downCouchPotatoColor())

        let tabBarController = DownTabBarController()
        tabBarController.viewControllers = [sabNZBdNavigationController, sickbeardViewController, couchPotatoViewController]
        
        downWindow.rootViewController = tabBarController
        window = downWindow
        downWindow.makeKeyAndVisible()
    }
    
}

