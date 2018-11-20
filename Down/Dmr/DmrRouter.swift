//
//  DmrRouter.swift
//  Down
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

protocol DmrRouting {
    var dmrRouter: DmrRouter? { get set }
}

class DmrRouter: ChildRouter, Depending {
    typealias Dependencies = RouterDependency
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
        navigationController.viewControllers = [viewControllerFactory.makeDmrRoot()]
    }
}

private extension DmrRouter {
    func configureTabBarItem() {
        let icon = R.image.tabbar_movies()?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
    }
}
