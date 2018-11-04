//
//  AppDelegate.swift
//  Down
//
//  Created by Ruud Puts on 13/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: Router!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard NSClassFromString("XCTest") == nil else {
            return true
        }

        window = UIWindow()

        let dependencies = DownDependencies.recursiveInit()
        router = Router(dependencies: dependencies, window: window!)
        dependencies.router = router

        router.start()

        NSLog(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")

        return true
    }
}
