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

    init(parent: Router, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController, database: DownDatabase) {
        self.parent = parent
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.database = database
    }
    
    func start() {
        navigationController.viewControllers = [decorate(viewController: viewControllerFactory.makeDvrRoot())]
    }
    
    func showDetail(of show: DvrShow) {
        let vc = decorate(viewController: viewControllerFactory.makeDvrDetail())
        guard let viewController = vc as? DvrShowDetailViewController else {
            return
        }
        
        viewController.show = show
        navigationController.pushViewController(viewController, animated: true)
    }

    func showAddShow() {
        let vc = decorate(viewController: viewControllerFactory.makeDvrAddShow())
        guard let viewController = vc as? DvrAddShowViewController else {
            return
        }

        parent.present(viewController, inNavigationController: true, animated: true)
    }

    func decorate(viewController vc: UIViewController) -> UIViewController {
        let viewController = parent.decorate(viewController: vc)

        if var dvrInteracting = viewController as? DvrApplicationInteracting {
            dvrInteracting.application = Down.dvrApplication
            dvrInteracting.interactorFactory = DvrInteractorFactory(database: database)
        }

        return viewController
    }
}
