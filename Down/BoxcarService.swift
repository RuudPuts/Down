//
//  Boxcar.swift
//  Down
//
//  Created by Ruud Puts on 07/05/2019.
//  Copyright © 2019 Mobile Sorcery. All rights reserved.
//

import Foundation
import Boxcar

protocol NotificationService {
    func requestRegistration()
    func registerDevice(token: Data)
    func registerFailed(error: Error)

    func applicationDidBecomeActive()

    func handleNotification(launchOptions: [AnyHashable: Any]?)
    func handleNotification(_ notification: [AnyHashable: Any])
    func clearNotifications()
}

protocol NotificationServiceDependency {
    var notificationService: NotificationService { get }
}

class BoxcarService: NSObject, NotificationService {
    private let options: [AnyHashable: Any] = [
        kBXC_CLIENT_KEY: "yud1RCrczLL0yv8ZHMOMbLETMAvHdmVK8BA203LK-2EK6lXoR4pmol6uPpLZtHNH",
        kBXC_CLIENT_SECRET: "x2Yp6VReZyutZbxQa8pzu3W-yZSZTJE6BiIvXhi_HDrS9N-mY5ySZiLSVGFHe__y",
        kBXC_API_URL: "https://console.boxcar.io",
        kBXC_LOGGING: true
    ]

    private var boxcar: Boxcar? {
        return Boxcar.sharedInstance() as? Boxcar
    }

    override init() {
        super.init()
        
        boxcar?.start(options: options, andMode: "development") {
            if let error = $0 {
                NSLog("[Boxcar] Error while starting: \(error)")
            }

            NSLog("[Boxcar] Started successfully")
        }
    }

    func requestRegistration() {
        boxcar?.registerDevice()
    }

    func registerDevice(token: Data) {
        boxcar?.didRegisterForRemoteNotifications(withDeviceToken: token)
    }

    func registerFailed(error: Error) {
        boxcar?.didFailToRegisterForRemoteNotificationsWithError(error)
    }

    func applicationDidBecomeActive() {
        boxcar?.applicationDidBecomeActive()
    }

    func handleNotification(launchOptions: [AnyHashable: Any]?) {
        guard
            let options = launchOptions,
            let notification = boxcar?.extractRemoteNotification(fromLaunchOptions: options) else {
            return
        }

        handleNotification(notification)
    }

    func handleNotification(_ notification: [AnyHashable: Any]) {
        boxcar?.trackNotification(notification)
        clearNotifications()
    }

    func clearNotifications() {
        boxcar?.cleanNotificationsAndBadge()
    }
}

extension BoxcarService: UNUserNotificationCenterDelegate { }
