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

    init(parent: Router, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController, database: DownDatabase) {
        self.parent = parent
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.database = database
    }

    func start() {
        navigationController.viewControllers = [decorate(viewController: viewControllerFactory.makeDmrRoot())]
    }

    func decorate(viewController vc: UIViewController) -> UIViewController {
        let viewController = parent.decorate(viewController: vc)

        if var DmrInteracting = viewController as? DmrApplicationInteracting {
            DmrInteracting.application = Down.dmrApplication
//            DmrInteracting.interactorFactory = DmrInteractorFactory(database: database)
        }

        return viewController
    }
}
