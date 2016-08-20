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

        startOnboarding()
        
        return true
    }
    
    func startOnboarding() {
        // Check if intro should be shown
        if !isSetup {
            let introViewController = DownIntroViewController(introType: .Welcome)
            let introNavigationController = UINavigationController(rootViewController: introViewController)
            introNavigationController.navigationBarHidden = true
            
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