//
//  DvrRouter.swift
//  Down
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import Parchment

protocol DvrRouting {
    var dvrRouter: DvrRouter? { get set }
}

class DvrRouter: ChildRouter, Depending {
    typealias Dependencies = RouterDependency & DvrApplicationDependency
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
        let rootViewController = viewControllerFactory.makeDvrRoot(viewControllers: [
            viewControllerFactory.makeDvrAiringSoon(),
            viewControllerFactory.makeDvrShows(),
            viewControllerFactory.makeDvrRecentlyAired()
        ])

        navigationController.viewControllers = [rootViewController]
    }
    
    func showDetail(of show: DvrShow, selectedEpisode: DvrEpisode? = nil) {
        let vc = viewControllerFactory.makeDvrDetail(show: show, selectedEpisode: selectedEpisode)
        guard let viewController = vc as? DvrShowDetailViewController else {
            return
        }

        navigationController.pushViewController(viewController, animated: true)
    }

    func showAddShow() {
        let vc = viewControllerFactory.makeDvrAddShow()
        guard let viewController = vc as? DvrAddShowViewController else {
            return
        }

        dependencies.router.present(viewController, inNavigationController: true, animated: true)
    }
}

private extension DvrRouter {
    func configureTabBarItem() {
        let icon = R.image.tabbar_shows()?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
    }
}
