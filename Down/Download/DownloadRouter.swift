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

class DownloadRouter: ChildRouter, Depending {
    typealias Dependencies = DownloadQueueItemDetailViewModel.Dependencies
        & RouterDependency
        & DownloadApplicationDependency
        & DatabaseDependency
    let dependencies: Dependencies

    var viewControllerFactory: ViewControllerProducing
    var navigationController: UINavigationController

    init(dependencies: Dependencies, viewControllerFactory: ViewControllerProducing, navigationController: UINavigationController) {
        self.dependencies = dependencies

        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController

        configureTabBarItem()
    }
    
    func start() {
        navigationController.viewControllers = [
            viewControllerFactory.makeDownloadOverview()
        ]
    }

    func showDetail(of item: DownloadItem) {
        var viewModel: DownloadItemDetailViewModel
        if let queueItem = item as? DownloadQueueItem {
            viewModel = DownloadQueueItemDetailViewModel(dependencies: dependencies, queueItem: queueItem)
        }
        else if let historyItem = item as? DownloadHistoryItem {
            viewModel = DownloadHistoryItemDetailViewModel(dependencies: dependencies, historyItem: historyItem)
        }
        else {
            fatalError("Unkown DownloadItemType")
        }

        navigationController.pushViewController(viewControllerFactory.makeDownloadItemDetail(viewModel: viewModel),
                                                animated: true)
    }
}

private extension DownloadRouter {
    func configureTabBarItem() {
        let icon = R.image.tabbar_downloads()?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: icon, tag: 0)
    }
}
