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

class DvrShowsViewController: UIViewController & Routing & DatabaseConsuming & DvrApplicationInteracting {
    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!
    var database: DownDatabase!
    var router: Router?

    let disposeBag = DisposeBag()

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!

    lazy var viewModel = DvrShowsViewModel(database: database,
                                           refreshCacheInteractor: dvrInteractorFactory.makeShowCacheRefreshInteractor(for: dvrApplication))
    lazy var collectionViewModel = DvrShowsCollectionViewModel(collectionView: collectionView,
                                                               router: router?.dvrRouter,
                                                               application: dvrApplication,
                                                               interactorFactory: dvrInteractorFactory)
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    func applyStyling() {
        view.style(as: .backgroundView)
        headerView.style(as: .headerView(for: dvrApplication.downType))
    }

    func configureCollectionView() {
        collectionViewModel.configure(collectionView)
    }

    func createAddShowsButton() {
        let toolbar = ButtonToolbar()
        toolbar.insets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        toolbar
            .addButton(title: "Add show", style: .successButton)
            .rx.tap
            .subscribe(onNext: { _ in
                self.router?.dvrRouter.showAddShow()
            })
            .disposed(by: disposeBag)

        collectionView.collectionHeaderView = toolbar
    }

    func applyViewModel() {
        viewModel.shows
            .subscribe(onNext: {
                self.collectionViewModel.shows = $0
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
