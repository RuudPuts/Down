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
    typealias Dependencies = DownloadApplicationDependency
    let dependencies: Dependencies

    var viewControllerFactory: ViewControllerProducing
    var navigationController: UINavigationController

    init(dependencies: Dependencies, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController) {
        self.dependencies = dependencies

        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController

        configureTabBarItem()
    }
    
    func start() {
        navigationController.viewControllers = [
            viewControllerFactory.makeDownloadStatus()
        ]
    }

    func showDetail(of item: DownloadItem) {
        let viewController = viewControllerFactory.makeDownloadItemDetail(for: item)
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension DownloadRouter {
    func configureTabBarItem() {
        let icon = R.image.tabbar_downloads()?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
    }
}
