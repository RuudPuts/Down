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

        PreferenceManager.sabNZBdHost = "http://192.168.178.10:8080"
        PreferenceManager.sabNZBdApiKey = "49b77b422da54f699a58562f3a1debaa"

        PreferenceManager.sickbeardHost = "http://192.168.178.10:8081"
        PreferenceManager.sickbeardApiKey = "e9c3be0f3315f09d7ceae37f1d3836cd"

        PreferenceManager.couchPotatoHost = "http://192.168.178.10:5050"
        PreferenceManager.couchPotatoApiKey = "fb3f91e38ba147b29514d56a24d17d9a"
        
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

