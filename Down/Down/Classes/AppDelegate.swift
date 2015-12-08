//
//  AppDelegate.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger
import DownKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var serviceManager: ServiceManager!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [NSObject: AnyObject]?) -> Bool {
        Instabug.startWithToken("dc9091202562420874c069cfc74b57fd", captureSource: IBGCaptureSourceUIKit, invocationEvent: IBGInvocationEventShake)

        PreferenceManager.sabNZBdHost = "192.168.178.10:8080"
        PreferenceManager.sabNZBdApiKey = "005a4296d8472a6ac787f09f24f2b70c"

        PreferenceManager.sickbeardHost = "192.168.178.10:8081"
        PreferenceManager.sickbeardApiKey = "e9c3be0f3315f09d7ceae37f1d3836cd"

        PreferenceManager.couchPotatoHost = "192.168.178.10"
        PreferenceManager.couchPotatoApiKey = "fb3f91e38ba147b29514d56a24d17d9a"
        
        serviceManager = ServiceManager()
        
        let log = XCGLogger.defaultInstance()
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: false, showLineNumbers: false, writeToFile: nil, fileLogLevel: .None)
        
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
        let sickbeardNavigationController = UINavigationController(rootViewController: sickbeardViewController)
        sickbeardNavigationController.navigationBarHidden = true
        
        let couchPotatoViewController = CouchPotatoViewController()
        couchPotatoViewController.tabBarItem = DownTabBarItem(title: "CouchPotato", image: UIImage(named: "couchpotato-tabbar"), tintColor: UIColor.downCouchPotatoColor())
        let couchPotatoNavigationController = UINavigationController(rootViewController: couchPotatoViewController)
        couchPotatoNavigationController.navigationBarHidden = true

        let tabBarController = DownTabBarViewController()
        tabBarController.viewControllers = [sabNZBdNavigationController, sickbeardNavigationController, couchPotatoNavigationController]
        
        downWindow.rootViewController = tabBarController
        window = downWindow
        downWindow.makeKeyAndVisible()
    }
    
}

