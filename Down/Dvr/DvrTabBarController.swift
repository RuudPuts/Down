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
    private let viewControllers: [UIViewController]

    init(dependencies: Dependencies, viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
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
        configurePagingController()
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

        let applicationType = dependencies.dvrApplication.downType
        headerView.style(as: .headerView(for: applicationType))
        pagingViewController.style(as: .pagingViewController(for: applicationType))
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

    private func configurePagingController() {
        pagingViewController.delegate = self
        pagingViewController.select(index: 1, animated: false)
    }
}

extension DvrTabBarController: PagingViewControllerDelegate {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: viewControllers[index].title ?? "")
    }
}
