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
    let dependencies: DownDependencies
    let viewControllerFactory: ViewControllerFactory
    
    var downloadRouter: DownloadRouter!
    var dvrRouter: DvrRouter!
    var dmrRouter: DmrRouter!
    var settingsRouter: SettingsRouter!
    
    var tabBarController: UITabBarController?
    
    init(dependencies: DownDependencies, window: UIWindow, viewControllerFactory: ViewControllerFactory) {
        self.window = window
        self.dependencies = dependencies
        self.viewControllerFactory = viewControllerFactory
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
        navigationController.navigationBar.style(as: .defaultNavigationBar)
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
}

extension Router {
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
        dependencies.reloadApplication(type)

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
            let tabIndex = min(typeIndex, (tabBarController.viewControllers?.count ?? 1) - 1)
            tabBarController.viewControllers?.insert(viewController, at: tabIndex)
            updateTabBarHidden()
        }

        return viewController
    }

    private func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.style(as: .defaultNavigationBar)

        return navigationController
    }

    func startDownloadRouter() -> UIViewController? {
        guard dependencies.downloadApplication != nil else {
            return nil
        }

        downloadRouter = DownloadRouter(dependencies: dependencies,
                                        viewControllerFactory: viewControllerFactory,
                                        navigationController: makeNavigationController())
        downloadRouter.start()

        return downloadRouter.navigationController
    }

    func startDvrRouter() -> UIViewController? {
        guard dependencies.dvrApplication != nil else {
            return nil
        }

        dvrRouter = DvrRouter(dependencies: dependencies,
                              viewControllerFactory: viewControllerFactory,
                              navigationController: makeNavigationController())
        dvrRouter.start()

        return dvrRouter.navigationController
    }

    func startDmrRouter() -> UIViewController? {
        guard dependencies.dmrApplication != nil else {
            return nil
        }


        dmrRouter = DmrRouter(dependencies: dependencies,
                              viewControllerFactory: viewControllerFactory,
                              navigationController: makeNavigationController())
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

protocol ChildRouter {
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
