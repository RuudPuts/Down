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

    func makeDvrRoot(viewControllers: [UIViewController]) -> UIViewController
    func makeDvrAiringSoon() -> UIViewController
    func makeDvrRecentlyAired() -> UIViewController
    func makeDvrShows() -> UIViewController
    func makeDvrDetail(show: DvrShow, selectedEpisode: DvrEpisode?) -> UIViewController
    func makeDvrAddShow() -> UIViewController

    func makeDmrRoot() -> UIViewController
}

class ViewControllerFactory: ViewControllerProducing, Depending {
    typealias Dependencies = AllDownDependencies
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension ViewControllerFactory {
    func makeSettings() -> UIViewController {
        let viewModel = SettingsViewModel(dependencies: dependencies)

        return SettingsViewController(dependencies: dependencies, viewModel: viewModel)
    }

    func makeApplicationSettings(for application: ApiApplication) -> UIViewController {
        let viewController = ApplicationSettingsViewController(dependencies: dependencies,
                                                               application: application)

        return viewController
    }
}

extension ViewControllerFactory {
    func makeDownloadStatus() -> UIViewController {
        return DownloadStatusViewController(dependencies: dependencies,
                                            viewModel: DownloadStatusViewModel(dependencies: dependencies))
    }

    func makeDownloadItemDetail(for item: DownloadItem) -> UIViewController {
        let viewModel = DownloadItemDetailViewModel(dependencies: dependencies, item: item)

        return DownloadItemDetailViewController(dependencies: dependencies, viewModel: viewModel)
    }

    func makeDvrRoot(viewControllers: [UIViewController]) -> UIViewController {
        return DvrPagingViewController(dependencies: dependencies,
                                       viewModel: DvrPagingViewModel(dependencies: dependencies),
                                       viewControllers: viewControllers,
                                       application: dependencies.dvrApplication)
    }
}

extension ViewControllerFactory {
    func makeDvrAiringSoon() -> UIViewController {
        return DvrAiringSoonViewController(dependencies: dependencies,
                                           viewModel: DvrAiringSoonViewModel(dependencies: dependencies))
    }

    func makeDvrRecentlyAired() -> UIViewController {
        return DvrRecentlyAiredViewController(dependencies: dependencies,
                                              viewModel: DvrRecentlyAiredViewModel(dependencies: dependencies))
    }

    func makeDvrShows() -> UIViewController {
        return DvrShowsViewController(dependencies: dependencies,
                                      viewModel: DvrShowsViewModel(dependencies: dependencies))
    }

    func makeDvrDetail(show: DvrShow, selectedEpisode: DvrEpisode?) -> UIViewController {
        let viewModel = DvrShowDetailsViewModel(dependencies: dependencies, show: show)

        return DvrShowDetailViewController(dependencies: dependencies,
                                           viewModel: viewModel,
                                           selectedEpisode: selectedEpisode)
    }

    func makeDvrAddShow() -> UIViewController {
        return DvrAddShowViewController(dependencies: dependencies,
                                        viewModel: DvrAddShowViewModel(dependencies: dependencies))
    }
}

extension ViewControllerFactory {
    func makeDmrRoot() -> UIViewController {
        return DmrStatusViewController(dependencies: dependencies)
    }
}
