//
//  SettingsRouter.swift
//  Down
//
//  Created by Ruud Puts on 03/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class SettingsRouter: ChildRouter {
    var parent: Router
    var viewControllerFactory: ViewControllerProducing
    var navigationController: UINavigationController

    init(parent: Router, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController) {
        self.parent = parent
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController

        configureTabBarItem()
    }

    func start() {
        let viewController = viewControllerFactory.makeSettings()

        navigationController.viewControllers = [viewController]
    }

    func showSettings(for application: ApiApplication) {
        let viewController = viewControllerFactory.makeApplicationSettings(for: application)

        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension SettingsRouter {
    func configureTabBarItem() {
        let icon = R.image.tabbar_settings()?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
    }
}
