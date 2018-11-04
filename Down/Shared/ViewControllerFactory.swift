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
    func makeSettings(viewModel: SettingsViewModel) -> UIViewController
    func makeApplicationSettings(for application: ApiApplication) -> UIViewController

    func makeDownloadOverview() -> UIViewController
    func makeDownloadItemDetail() -> UIViewController

    func makeDvrShows() -> UIViewController
    func makeDvrDetail() -> UIViewController
    func makeDvrAddShow() -> UIViewController

    func makeDmrRoot() -> UIViewController
}

class ViewControllerFactory: ViewControllerProducing, Depending {
    typealias Dependencies = AllDownDependencies
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeSettings(viewModel: SettingsViewModel) -> UIViewController {
        return SettingsViewController(dependencies: dependencies,
                                      viewModel: viewModel)
    }

    func makeApplicationSettings(for application: ApiApplication) -> UIViewController {
        let viewController = ApplicationSettingsViewController(dependencies: dependencies)
        viewController.apiApplication = application

        return viewController
    }

    func makeDownloadOverview() -> UIViewController {
        return DownloadViewController(dependencies: dependencies)
    }

    func makeDownloadItemDetail() -> UIViewController {
        return DownloadItemDetailViewController(dependencies: dependencies)
    }

    func makeDvrShows() -> UIViewController {
        return DvrShowsViewController(dependencies: dependencies)
    }

    func makeDvrDetail() -> UIViewController {
        return DvrShowDetailViewController()
    }

    func makeDvrAddShow() -> UIViewController {
        return DvrAddShowViewController(dependencies: dependencies)
    }

    func makeDmrRoot() -> UIViewController {
        return DmrStatusViewController()
    }
}
