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
    
    var rootViewController: UIViewController? {
        return window.rootViewController
    }
    
    init(window: UIWindow, viewControllerFactory: ViewControllerProducing, database: DownDatabase = RealmDatabase.default) {
        self.window = window
        self.viewControllerFactory = viewControllerFactory
        self.database = database
    }
    
    func start() {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            startDownloadRouter(tabBarController: tabBarController),
            startDvrRouter(tabBarController: tabBarController),
            startMvrRouter(tabBarController: tabBarController),
            startSettingsRouter(tabBarController: tabBarController)
        ].compactMap { $0 }
        tabBarController.tabBar.style(as: .defaultTabBar)
        tabBarController.tabBar.isHidden = tabBarController.viewControllers?.count ?? 0 < 2
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func showSettings(application: ApiApplication) {
        guard let tabbarController = rootViewController as? UITabBarController,
            let navigationController = tabbarController.viewControllers?[tabbarController.selectedIndex] as? UINavigationController else {
            return
        }

        let viewController = decorate(viewController: viewControllerFactory.makeApplicationSettings(for: application))
        navigationController.pushViewController(viewController, animated: true)
    }

    func present(_ viewController: UIViewController, inNavigationController: Bool, animated: Bool) {
        guard inNavigationController else {
            rootViewController?.present(viewController, animated: true, completion: nil)
            return
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain,
                                                                          target: self,
                                                                          action: #selector(aaa))

        present(navigationController, inNavigationController: false, animated: animated)
    }

    @objc
    func aaa() {
        rootViewController?.dismiss(animated: true, completion: nil)
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

private extension Router {
    func startDownloadRouter(tabBarController: UITabBarController) -> UIViewController? {
        guard let application = Down.persistence.load(type: .sabnzbd) as? DownloadApplication else {
            return nil
        }

        let icon = R.image.tabbar_downloads()?.withRenderingMode(.alwaysOriginal)
        let tabbarItem = UITabBarItem(title: nil, image: icon, tag: 0)

        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabbarItem

        downloadRouter = DownloadRouter(parent: self,
                                        application: application,
                                        viewControllerFactory: viewControllerFactory,
                                        navigationController: navigationController,
                                        database: database)
        downloadRouter.start()

        return navigationController
    }

    func startDvrRouter(tabBarController: UITabBarController) -> UIViewController? {
        guard let application = Down.persistence.load(type: .sickbeard) as? DvrApplication else {
            return nil
        }

        let icon = R.image.tabbar_shows()?.withRenderingMode(.alwaysOriginal)
        let tabbarItem = UITabBarItem(title: nil, image: icon, tag: 1)

        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabbarItem

        dvrRouter = DvrRouter(parent: self,
                              application: application,
                              viewControllerFactory: viewControllerFactory,
                              navigationController: navigationController,
                              database: database)
        dvrRouter.start()

        return navigationController
    }

    func startMvrRouter(tabBarController: UITabBarController) -> UIViewController? {
        guard let application = Down.persistence.load(type: .couchpotato) as? DmrApplication else {
            return nil
        }

        let icon = R.image.tabbar_movies()?.withRenderingMode(.alwaysOriginal)
        let tabbarItem = UITabBarItem(title: nil, image: icon, tag: 1)

        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabbarItem

        dmrRouter = DmrRouter(parent: self,
                              application: application,
                              viewControllerFactory: viewControllerFactory,
                              navigationController: navigationController,
                              database: database)
        dmrRouter.start()

        return navigationController
    }

    func startSettingsRouter(tabBarController: UITabBarController) -> UIViewController {
        let icon = R.image.tabbar_settings()?.withRenderingMode(.alwaysOriginal)
        let tabbarItem = UITabBarItem(title: nil, image: icon, tag: 1)

        let viewController = decorate(viewController: viewControllerFactory.makeSettings())
        guard let settingsViewController = viewController as? SettingsViewController else {
            fatalError()
        }
        settingsViewController.viewModel = SettingsViewModel(showWelcomeMessage: true)

        let navigationController = UINavigationController(rootViewController: settingsViewController)
        navigationController.tabBarItem = tabbarItem

        return navigationController
    }
}

protocol Routing {
    var router: Router? { get set } //! Convert UI to Xibs to make non optional
}

protocol ChildRouter {
    var parent: Router { get set }
    var viewControllerFactory: ViewControllerProducing { get set }
}
