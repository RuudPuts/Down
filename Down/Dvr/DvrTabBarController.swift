//
//  DvrTabBarController.swift
//  Down
//
//  Created by Ruud Puts on 16/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import Parchment
import DownKit

class DvrTabBarController: UIViewController & Depending {
    typealias Dependencies = DvrShowsCollectionViewModel.Dependencies & RouterDependency & DvrApplicationDependency
    let dependencies: Dependencies

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var containerView: UIView!

    private let pagingViewController: FixedPagingViewController

    init(dependencies: Dependencies, viewControllers: [UIViewController]) {
        self.dependencies = dependencies
        pagingViewController = FixedPagingViewController(viewControllers: viewControllers)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        showPagingController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = navigationController,
            navigationController.viewControllers.count > 1 {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }

    private func applyStyling() {
        view.style(as: .backgroundView)
        headerView.style(as: .headerView(for: dependencies.dvrApplication.downType))
    }

    private func showPagingController() {
        addChild(pagingViewController)
        containerView.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
}
