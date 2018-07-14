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
    func makeApplicationSettings(for application: ApiApplication) -> UIViewController

    func makeDownloadRoot() -> UIViewController

    func makeDvrRoot() -> UIViewController
    func makeDvrDetail() -> UIViewController
}

class ViewControllerFactory: ViewControllerProducing {
    func makeApplicationSettings(for application: ApiApplication) -> UIViewController {
        let viewController = ApplicationSettingsViewController()
        viewController.application = application

        return viewController
    }

    func makeDownloadRoot() -> UIViewController {
        return DownloadViewController()
    }

    func makeDvrRoot() -> UIViewController {
        return DvrViewController()
    }

    func makeDvrDetail() -> UIViewController {
        return DvrDetailViewController()
    }
}
