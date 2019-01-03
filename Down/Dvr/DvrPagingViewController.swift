//
//  DvrPagingViewController.swift
//  Down
//
//  Created by Ruud Puts on 22/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation
import DownKit
import RxSwift
import RxCocoa

class DvrPagingViewController: PagingViewController, Depending {
    typealias Dependencies = RouterDependency
    let dependencies: Dependencies

    let refreshCacheSubject = BehaviorSubject(value: Void())

    override var nibName: String? {
        return "PagingViewController"
    }

    init(dependencies: Dependencies, viewModel: PagingViewModel, viewControllers: [UIViewController], application: ApiApplication) {
        self.dependencies = dependencies

        super.init(viewModel: viewModel, viewControllers: viewControllers, application: application)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showContextMenu() {
        let actionController = DownActionController(applicationType: application.downType)

        actionController.addAction(title: "Add show", image: R.image.icon_plus(), handler: { _ in
            self.dependencies.router.dvrRouter.showAddShow()
        })

        actionController.addCancelSection()

        present(actionController, animated: true, completion: nil)
    }
}
