//
//  DownloadRouter.swift
//  Down
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

protocol DownloadRouting {
    var downloadRouter: DownloadRouter? { get set }
}

class DownloadRouter: ChildRouter {
    var parent: Router
    var viewControllerFactory: ViewControllerProducing
    var navigationController: UINavigationController
    var database: DownDatabase
    var application: DownloadApplication?

    init(parent: Router, application: DownloadApplication?, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController, database: DownDatabase) {
        self.parent = parent
        self.application = application
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.database = database

        configureTabBarItem()
    }
    
    func start() {
        navigationController.viewControllers = [
            parent.decorate(viewController: viewControllerFactory.makeDownloadRoot())
        ]
    }

    func showDetail(of item: DownloadItem) {
        let vc = parent.decorate(viewController: viewControllerFactory.makeDownloadItemDetail())
        guard let viewController = vc as? DownloadItemDetailViewController else {
            return
        }

        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension DownloadRouter {
    func configureTabBarItem() {
        let icon = R.image.tabbar_downloads()?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
    }
}
