//
//  AppDelegate.swift
//  Down
//
//  Created by Ruud Puts on 13/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: Router!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard NSClassFromString("XCTest") == nil else {
            return true
        }

        Fabric.with([Crashlytics.self])

        window = UIWindow()

        let dependencies = DownDependencies()
        let viewControllerFactory = ViewControllerFactory(dependencies: dependencies)

        router = Router(dependencies: dependencies, window: window!, viewControllerFactory: viewControllerFactory)
        dependencies.router = router

        router.start()

        NSLog(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")

        return true
    }
}
