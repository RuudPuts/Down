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

class DmrRouter: ChildRouter {
    var parent: Router
    var viewControllerFactory: ViewControllerProducing
    var navigationController: UINavigationController
    var database: DownDatabase
    var application: DmrApplication?

    init(parent: Router, application: DmrApplication?, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController, database: DownDatabase) {
        self.parent = parent
        self.application = application
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.database = database

        configureTabBarItem()
    }

    func start() {
        navigationController.viewControllers = [decorate(viewController: viewControllerFactory.makeDmrRoot())]
    }

    func decorate(viewController vc: UIViewController) -> UIViewController {
        let viewController = parent.decorate(viewController: vc)

        if var dmrInteracting = viewController as? DmrApplicationInteracting {
            dmrInteracting.application = application
//            DmrInteracting.interactorFactory = DmrInteractorFactory(database: database)
        }

        return viewController
    }
}

private extension DmrRouter {
    func configureTabBarItem() {
        let icon = R.image.tabbar_movies()?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
    }
}
