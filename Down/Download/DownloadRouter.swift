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
    var application: DownloadApplication

    init(parent: Router, application: DownloadApplication, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController, database: DownDatabase) {
        self.parent = parent
        self.application = application
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.database = database
    }
    
    func start() {
        navigationController.viewControllers = [
            decorate(viewController: viewControllerFactory.makeDownloadRoot())
        ]
    }

    func decorate(viewController vc: UIViewController) -> UIViewController {
        let viewController = parent.decorate(viewController: vc)

        if var downloadInteracting = viewController as? DownloadApplicationInteracting {
            downloadInteracting.application = application
            downloadInteracting.interactorFactory = DownloadInteractorFactory(dvrDatabase: parent.database)
        }

        return viewController
    }
}
