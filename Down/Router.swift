//
//  Router.swift
//  Down
//
//  Created by Ruud Puts on 07/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import UIKit

protocol Routing {
    var router: Router? { get set }
}

class Router {    
    let window: UIWindow
    let storyboard: UIStoryboard
    let database: DownDatabase
    
    var navigationController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    
    init(window: UIWindow, storyboard: UIStoryboard, database: DownDatabase = RealmDatabase.default) {
        self.window = window
        self.storyboard = storyboard
        self.database = database
    }
    
    enum Identifier: String {
        case root
        case detail
    }
    
    func start() {
        let rootViewController = makeViewController(.root)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showDetail(of show: DvrShow) {
        guard let viewController = makeViewController(.detail) as? DetailViewController else {
            return
        }
        
        viewController.show = show
        navigationController?.pushViewController(viewController, animated: true)
    }
}

typealias RouterViewController = UIViewController & Routing

private extension Router {
    func makeViewController(_ identifier: Identifier) -> UIViewController & Routing {
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        guard let routingViewController = viewController as? RouterViewController else {
            fatalError("bye")
        }
        decorate(routingViewController)
        
        return routingViewController
    }
    
    func decorate(_ viewController: RouterViewController) {
        var controller = viewController
        controller.router = self
        
        if var databaseConuming = controller as? DatabaseConsuming {
            databaseConuming.database = database
        }
        
        if var dvrInteracting = controller as? DvrApplicationInteracting {
            dvrInteracting.application = Down.dvrApplication
            dvrInteracting.interactorFactory = DvrInteractorFactory(database: database)
        }
    }
}
