//
//  Router.swift
//  Down
//
//  Created by Ruud Puts on 07/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import UIKit

class Router {    
    let window: UIWindow
    let storyboard: UIStoryboard
    let database: DownDatabase
    
    var downloadRouter: DownloadRouter!
    var dvrRouter: DvrRouter!
    
    var navigationController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    
    init(window: UIWindow, storyboard: UIStoryboard, database: DownDatabase = RealmDatabase.default) {
        self.window = window
        self.storyboard = storyboard
        self.database = database
    }
    
    enum Identifier: String {
        case root
        case detail
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        let downloadViewController = startDownloadRouter(tabBarController: tabBarController)
        let dvrViewController = startDvrRouter(tabBarController: tabBarController)
        tabBarController.viewControllers = [downloadViewController, dvrViewController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func startDownloadRouter(tabBarController: UITabBarController) -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "Downloads", image: nil, tag: 0)
        downloadRouter = DownloadRouter(storyboard: storyboard,
                                        navigationController: navigationController,
                                        database: database)
        downloadRouter.start()
        
        return navigationController
    }
    
    private func startDvrRouter(tabBarController: UITabBarController) -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "Shows", image: nil, tag: 0)
        dvrRouter = DvrRouter(storyboard: storyboard,
                              navigationController: navigationController,
                              database: database)
        dvrRouter.start()
        
        return navigationController
    }
}
