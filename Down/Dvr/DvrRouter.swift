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

class DvrRouter {
    let storyboard: UIStoryboard
    var navigationController: UINavigationController
    let database: DownDatabase
    
    init(storyboard: UIStoryboard, navigationController: UINavigationController, database: DownDatabase) {
        self.storyboard = storyboard
        self.navigationController = navigationController
        self.database = database
    }
    
    enum Identifier: String {
        case root = "dvrRoot"
        case detail = "dvrDetail"
    }
    
    func start() {
        navigationController.viewControllers = [makeViewController(.root)]
    }
    
    func showDetail(of show: DvrShow) {
        guard let viewController = makeViewController(.detail) as? DvrDetailViewController else {
            return
        }
        
        viewController.show = show
        navigationController.pushViewController(viewController, animated: true)
    }
}

typealias DvrRouterViewController = UIViewController & DvrRouting

private extension DvrRouter {
    func makeViewController(_ identifier: Identifier) -> DvrRouterViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        guard let routingViewController = viewController as? DvrRouterViewController else {
            fatalError("bye")
        }
        decorate(routingViewController)
        
        return routingViewController
    }
    
    func decorate(_ viewController: DvrRouterViewController) {
        var controller = viewController
        controller.dvrRouter = self
        
        if var databaseConuming = controller as? DatabaseConsuming {
            databaseConuming.database = database
        }
        
        if var dvrInteracting = controller as? DvrApplicationInteracting {
            dvrInteracting.application = Down.dvrApplication
            dvrInteracting.interactorFactory = DvrInteractorFactory(database: database)
        }
    }
}
