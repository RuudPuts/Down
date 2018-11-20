//
//  ViewControllerFactory.swift
//  Down
//
//  Created by Ruud Puts on 12/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

protocol ViewControllerProducing {
    func makeSettings() -> UIViewController
    func makeApplicationSettings(for application: ApiApplication) -> UIViewController

    func makeDownloadStatus() -> UIViewController
    func makeDownloadItemDetail(for item: DownloadItem) -> UIViewController

    func makeDvrShows() -> UIViewController
    func makeDvrDetail(show: DvrShow) -> UIViewController
    func makeDvrAddShow() -> UIViewController

    func makeDmrRoot() -> UIViewController
}

class ViewControllerFactory: ViewControllerProducing, Depending {
    typealias Dependencies = AllDownDependencies
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeSettings() -> UIViewController {
        let viewModel = SettingsViewModel(dependencies: dependencies)

        return SettingsViewController(dependencies: dependencies, viewModel: viewModel)
    }

    func makeApplicationSettings(for application: ApiApplication) -> UIViewController {
        let viewController = ApplicationSettingsViewController(dependencies: dependencies,
                                                               application: application)

        return viewController
    }

    func makeDownloadStatus() -> UIViewController {
        return DownloadStatusViewController(dependencies: dependencies,
                                      viewModel: DownloadStatusViewModel(dependencies: dependencies))
    }

    func makeDownloadItemDetail(for item: DownloadItem) -> UIViewController {
        let viewModel = DownloadItemDetailViewModel(dependencies: dependencies, item: item)

        return DownloadItemDetailViewController(dependencies: dependencies, viewModel: viewModel)
    }

    func makeDvrShows() -> UIViewController {
        return DvrShowsViewController(dependencies: dependencies,
                                      viewModel: DvrShowsViewModel(dependencies: dependencies))
    }

    func makeDvrDetail(show: DvrShow) -> UIViewController {
        let viewModel = DvrShowDetailsViewModel(dependencies: dependencies, show: show)
        
        return DvrShowDetailViewController(dependencies: dependencies,
                                           viewModel: viewModel)
    }

    func makeDvrAddShow() -> UIViewController {
        return DvrAddShowViewController(dependencies: dependencies,
                                        viewModel: DvrAddShowViewModel(dependencies: dependencies))
    }

    func makeDmrRoot() -> UIViewController {
        return DmrStatusViewController(dependencies: dependencies)
    }
}
