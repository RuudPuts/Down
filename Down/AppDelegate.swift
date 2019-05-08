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
    var notificationService: NotificationService!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard NSClassFromString("XCTest") == nil else {
            return true
        }

        Fabric.with([Crashlytics.self])

        window = UIWindow()

        let dependencies = DownDependencies()
        notificationService = dependencies.notificationService
        notificationService.handleNotification(launchOptions: launchOptions)
        notificationService.requestRegistration()

        let viewControllerFactory = ViewControllerFactory(dependencies: dependencies)

        router = Router(dependencies: dependencies, window: window!, viewControllerFactory: viewControllerFactory)
        dependencies.router = router

        router.start()

        NSLog(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        notificationService.applicationDidBecomeActive()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationService.registerDevice(token: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        notificationService.registerFailed(error: error)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        notificationService.handleNotification(userInfo)
        completionHandler(.noData)
    }
}
