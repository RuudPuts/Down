//
//  Router.swift
//  Down
//
//  Created by Ruud Puts on 07/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import UIKit

class Router {    
    let window: UIWindow
    let viewControllerFactory: ViewControllerProducing
    let database: DownDatabase
    
    var downloadRouter: DownloadRouter!
    var dvrRouter: DvrRouter!
    var dmrRouter: DmrRouter!
    var settingsRouter: SettingsRouter!
    
    var tabBarController: UITabBarController?
    
    init(window: UIWindow, viewControllerFactory: ViewControllerProducing, database: DownDatabase = RealmDatabase.default) {
        self.window = window
        self.viewControllerFactory = viewControllerFactory
        self.database = database
    }
    
    func start() {
        var viewControllers: [UIViewController] = ApiApplicationType.allValues
            .map {
                startRouter(type: $0)
            }
            .compactMap { $0 }

        viewControllers.append(startSettingsRouter())

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        tabBarController.tabBar.style(as: .defaultTabBar)
        tabBarController.tabBar.isHidden = viewControllers.count < 2
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        self.tabBarController = tabBarController
    }

    func present(_ viewController: UIViewController, inNavigationController: Bool, animated: Bool) {
        guard inNavigationController else {
            tabBarController?.present(viewController, animated: true, completion: nil)
            return
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain,
                                                                          target: self,
                                                                          action: #selector(closePresentedViewController))

        present(navigationController, inNavigationController: false, animated: animated)
    }

    @objc
    func closePresentedViewController() {
        tabBarController?.dismiss(animated: true, completion: nil)
    }

    func close(viewController: UIViewController) {
        if let presenter = viewController.presentingViewController {
            presenter.dismiss(animated: true, completion: nil)
        }
        else if let navigationController = viewController.navigationController {
            navigationController.popViewController(animated: true)
        }
    }

    func decorate(viewController: UIViewController) -> UIViewController {
        if var routingViewController = viewController as? Routing {
            routingViewController.router = self
        }

        if var databaseConuming = viewController as? DatabaseConsuming {
            databaseConuming.database = database
        }

        if var apiApplicationInteractor = viewController as? ApiApplicationInteracting {
            //! UGH
            apiApplicationInteractor.interactorFactory = ApiApplicationInteractorFactory()
        }

        return viewController
    }
}

extension Router {
    func restartRouter(type: ApiApplicationType) {
        stopRouter(type: type)
        startRouter(type: type)

        tabBarController?.tabBar.isHidden = (tabBarController?.viewControllers?.count ?? 0) < 2
    }

    private func routerStarted(type: ApiApplicationType) -> Bool {
        switch type {
        case .download: return downloadRouter != nil
        case .dvr: return dvrRouter != nil
        case .dmr: return dmrRouter != nil
        }
    }

    private func stopRouter(type: ApiApplicationType) {
        guard routerStarted(type: type) else {
            return
        }

        if let index = ApiApplicationType.allValues.index(of: type) {
            tabBarController?.viewControllers?.remove(at: index)
        }

        switch type {
        case .download: downloadRouter = nil
        case .dvr: dvrRouter = nil
        case .dmr: dmrRouter = nil
        }
    }

    @discardableResult
    private func startRouter(type: ApiApplicationType) -> UIViewController? {
        let vc: UIViewController?

        switch type {
        case .download: vc = startDownloadRouter()
        case .dvr: vc = startDvrRouter()
        case .dmr: vc = startDmrRouter()
        }

        guard let viewController = vc,
              let index = ApiApplicationType.allValues.index(of: type) else {
            return nil
        }

        tabBarController?.viewControllers?.insert(viewController, at: index)

        return viewController
    }

    func startDownloadRouter() -> UIViewController? {
        guard let application = Down.persistence.load(type: .sabnzbd) as? DownloadApplication else {
            return nil
        }

        let navigationController = UINavigationController()
        downloadRouter = DownloadRouter(parent: self,
                                        application: application,
                                        viewControllerFactory: viewControllerFactory,
                                        navigationController: navigationController,
                                        database: database)
        downloadRouter.start()

        return navigationController
    }

    func startDvrRouter() -> UIViewController? {
        guard let application = Down.persistence.load(type: .sickbeard) as? DvrApplication else {
            return nil
        }

        let navigationController = UINavigationController()
        dvrRouter = DvrRouter(parent: self,
                              application: application,
                              viewControllerFactory: viewControllerFactory,
                              navigationController: navigationController,
                              database: database)
        dvrRouter.start()

        return navigationController
    }

    func startDmrRouter() -> UIViewController? {
        guard let application = Down.persistence.load(type: .couchpotato) as? DmrApplication else {
            return nil
        }

        let navigationController = UINavigationController()
        dmrRouter = DmrRouter(parent: self,
                              application: application,
                              viewControllerFactory: viewControllerFactory,
                              navigationController: navigationController,
                              database: database)
        dmrRouter.start()

        return navigationController
    }

    func startSettingsRouter() -> UIViewController {
        let navigationController = UINavigationController()
        settingsRouter = SettingsRouter(parent: self,
                                        viewControllerFactory: viewControllerFactory,
                                        navigationController: navigationController)
        settingsRouter.start()

        return navigationController
    }
}

protocol Routing {
    var router: Router? { get set } //! Convert UI to Xibs to make non optional
}

protocol ChildRouter {
    var parent: Router { get set }
    var viewControllerFactory: ViewControllerProducing { get set }

    func start()
}
