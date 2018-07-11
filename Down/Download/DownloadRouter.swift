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

class DownloadRouter: ApplicationRouter {
    let storyboard: UIStoryboard
    var navigationController: UINavigationController
    let database: DownDatabase
    
    init(storyboard: UIStoryboard, navigationController: UINavigationController, database: DownDatabase) {
        self.storyboard = storyboard
        self.navigationController = navigationController
        self.database = database
    }
    
    enum Identifier: String {
        case root = "downloadRoot"
    }
    
    func start() {
        navigationController.viewControllers = [makeViewController(.root)]
    }
}

typealias DownloadRouterViewController = UIViewController & DownloadRouting

private extension DownloadRouter {
    func makeViewController(_ identifier: Identifier) -> DownloadRouterViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        guard let routingViewController = viewController as? DownloadRouterViewController else {
            fatalError("bye")
        }
        decorate(routingViewController)
        
        return routingViewController
    }
    
    func decorate(_ viewController: DownloadRouterViewController) {
        var controller = viewController
        controller.downloadRouter = self
        
        if var databaseConuming = controller as? DatabaseConsuming {
            databaseConuming.database = database
        }
        
        if var downloadInteracting = controller as? DownloadApplicationInteracting {
            downloadInteracting.application = Down.downloadApplication
            downloadInteracting.interactorFactory = DownloadInteractorFactory(dvrDatabase: database)
        }
    }
}
