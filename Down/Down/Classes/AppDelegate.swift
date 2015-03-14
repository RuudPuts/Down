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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        initializeWindow()
        
        return true
    }
    
    func initializeWindow() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let viewController: ViewController = ViewController(nibName: "ViewController", bundle: nil)
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
    }
    
}

