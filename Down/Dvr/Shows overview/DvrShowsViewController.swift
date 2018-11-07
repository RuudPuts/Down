//
//  DvrShowsViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa
import UIKit

class DvrShowsViewController: UIViewController & Depending {
    typealias Dependencies = DvrShowsCollectionViewModel.Dependencies & RouterDependency & DvrApplicationDependency
    let dependencies: Dependencies

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!

    private let viewModel: DvrShowsViewModel
    private var collectionViewModel: DvrShowsCollectionViewModel!

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies, viewModel: DvrShowsViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        collectionViewModel = DvrShowsCollectionViewModel(dependencies: dependencies,
                                                          collectionView: collectionView)

        configureCollectionView()
        createAddShowsButton()
        applyStyling()
        applyViewModel()
        viewModel.refreshShowCache()
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

    private func configureCollectionView() {
        collectionViewModel.configure(collectionView)
    }

    private func createAddShowsButton() {
        let toolbar = ButtonToolbar()
        toolbar.insets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        toolbar
            .addButton(title: "Add show", style: .successButton)
            .rx.tap
            .subscribe(onNext: { _ in
                self.dependencies.router.dvrRouter.showAddShow()
            })
            .disposed(by: disposeBag)

        collectionView.collectionHeaderView = toolbar
    }

    private func applyViewModel() {
        viewModel.shows
            .subscribe(onNext: {
                self.collectionViewModel.shows = $0
            })
            .disposed(by: disposeBag)
    }
}
