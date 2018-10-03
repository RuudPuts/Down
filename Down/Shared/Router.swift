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
        makeDownloadRouter()
        makeDvrRouter()
        makeDmrRouter()

        var viewControllers: [UIViewController] = ApiApplicationType.allValues
            .map {
                startRouter(type: $0)
            }
            .compactMap { $0 }
        viewControllers.append(startSettingsRouter())

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        tabBarController.tabBar.style(as: .defaultTabBar)
        updateTabBarHidden()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        self.tabBarController = tabBarController
    }

    private func updateTabBarHidden() {
        tabBarController?.tabBar.isHidden = tabBarController?.viewControllers?.count ?? 0 < 2
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

        if var apiInteracting = viewController as? ApiApplicationInteracting {
            apiInteracting.apiInteractorFactory = ApiApplicationInteractorFactory()
        }

        if var downloadInteracting = viewController as? DownloadApplicationInteracting {
            if let application = downloadRouter?.application {
                downloadInteracting.downloadApplication = application
            }
            downloadInteracting.downloadInteractorFactory = DownloadInteractorFactory(dvrDatabase: database)
        }

        if var dvrInteracting = viewController as? DvrApplicationInteracting {
            if let application = dvrRouter?.application {
                dvrInteracting.dvrApplication = application
            }
            dvrInteracting.dvrInteractorFactory = DvrInteractorFactory(database: database)
        }

        return viewController
    }
}

extension Router {
    func store(application: ApiApplication) {
        switch application.type {
        case .download:
            downloadRouter.application = application as? DownloadApplication
        case .dvr:
            dvrRouter.application = application as? DvrApplication
        case .dmr:
            dmrRouter.application = application as? DmrApplication
        }
    }

    private func childRouter(ofType type: ApiApplicationType) -> ChildRouter {
        switch type {
        case .download: return downloadRouter
        case .dvr: return dvrRouter
        case .dmr: return dmrRouter
        }
    }

    func restartRouter(type: ApiApplicationType) {
        stopRouter(type: type)
        startRouter(type: type)
    }

    private func routerStarted(type: ApiApplicationType) -> Bool {
        return !childRouter(ofType: type).navigationController.viewControllers.isEmpty
    }

    private func stopRouter(type: ApiApplicationType) {
        guard routerStarted(type: type) else {
            return
        }

        childRouter(ofType: type).stop()

        if let index = ApiApplicationType.allValues.index(of: type) {
            tabBarController?.viewControllers?.remove(at: index)
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
              let typeIndex = ApiApplicationType.allValues.index(of: type) else {
            return nil
        }

        if let tabBarController = tabBarController {
            let tabIndex = min(typeIndex, tabBarController.viewControllers?.count ?? 1 - 1)
            tabBarController.viewControllers?.insert(viewController, at: tabIndex)
            updateTabBarHidden()
        }

        return viewController
    }

    func makeDownloadRouter() {
        let application = Down.persistence.load(type: .sabnzbd) as? DownloadApplication

        let navigationController = UINavigationController()
        downloadRouter = DownloadRouter(parent: self,
                                        application: application,
                                        viewControllerFactory: viewControllerFactory,
                                        navigationController: navigationController,
                                        database: database)
    }

    func startDownloadRouter() -> UIViewController? {
        guard downloadRouter.application != nil else {
            return nil
        }

        downloadRouter.start()

        return downloadRouter.navigationController
    }

    func makeDvrRouter() {
        let application = Down.persistence.load(type: .sickbeard) as? DvrApplication

        let navigationController = UINavigationController()
        dvrRouter = DvrRouter(parent: self,
                              application: application,
                              viewControllerFactory: viewControllerFactory,
                              navigationController: navigationController,
                              database: database)
    }

    func startDvrRouter() -> UIViewController? {
        guard dvrRouter.application != nil else {
            return nil
        }

        dvrRouter.start()

        return dvrRouter.navigationController
    }

    func makeDmrRouter() {
        let application = Down.persistence.load(type: .couchpotato) as? DmrApplication

        let navigationController = UINavigationController()
        dmrRouter = DmrRouter(parent: self,
                              application: application,
                              viewControllerFactory: viewControllerFactory,
                              navigationController: navigationController,
                              database: database)
    }

    func startDmrRouter() -> UIViewController? {
        guard dmrRouter.application != nil else {
            return nil
        }

        dmrRouter.start()

        return dmrRouter.navigationController
    }

    func startSettingsRouter() -> UIViewController {
        settingsRouter = SettingsRouter(parent: self,
                                        viewControllerFactory: viewControllerFactory,
                                        navigationController: UINavigationController())
        settingsRouter.start()

        return settingsRouter.navigationController
    }
}

protocol Routing {
    var router: Router? { get set }
}

protocol ChildRouter {
    var parent: Router { get set }
    var navigationController: UINavigationController { get }
    var viewControllerFactory: ViewControllerProducing { get set }

    func start()
    func stop()
}

extension ChildRouter {
    func stop() {
        navigationController.viewControllers = []
    }
}
