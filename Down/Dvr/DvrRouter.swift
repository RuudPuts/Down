//
//  DvrRouter.swift
//  Down
//
//  Created by Ruud Puts on 24/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

protocol DvrRouting {
    var dvrRouter: DvrRouter? { get set }
}

class DvrRouter: ChildRouter {
    var parent: Router
    var viewControllerFactory: ViewControllerProducing
    var navigationController: UINavigationController
    var database: DownDatabase
    var application: DvrApplication?

    init(parent: Router, application: DvrApplication?, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController, database: DownDatabase) {
        self.parent = parent
        self.application = application
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.database = database

        configureTabBarItem()
    }
    
    func start() {
        navigationController.viewControllers = [parent.decorate(viewControllerFactory.makeDvrRoot())]
    }
    
    func showDetail(of show: DvrShow) {
        let vc = parent.decorate(viewControllerFactory.makeDvrDetail())
        guard let viewController = vc as? DvrShowDetailViewController else {
            return
        }
        
        viewController.show = show
        navigationController.pushViewController(viewController, animated: true)
    }

    func showAddShow() {
        let vc = parent.decorate(viewControllerFactory.makeDvrAddShow())
        guard let viewController = vc as? DvrAddShowViewController else {
            return
        }

        parent.present(viewController, inNavigationController: true, animated: true)
    }
}

private extension DvrRouter {
    func configureTabBarItem() {
        let icon = R.image.tabbar_shows()?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
    }
}
