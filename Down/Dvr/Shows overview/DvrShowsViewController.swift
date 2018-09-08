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
    var application: DvrApplication!
    var interactorFactory: DvrInteractorProducing!
    var database: DownDatabase!
    var router: Router?

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!

    let disposeBag = DisposeBag()

    lazy var viewModel = DvrShowsViewModel(database: database,
                                           refreshCacheInteractor: interactorFactory.makeShowCacheRefreshInteractor(for: application))
    lazy var collectionViewModel = DvrShowsCollectionViewModel(collectionView: collectionView,
                                                               router: router?.dvrRouter,
                                                               application: application,
                                                               interactorFactory: interactorFactory)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        configureHeaderView()
        configureCollectionView()
        applyViewModel()
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
    }

    func configureHeaderView() {
        headerView.style(as: .headerView(for: application.downType))
        headerView.button?.rx.tap
            .subscribe(onNext: { _ in
                self.router?.showSettings(application: self.application)
//                self.router?.dvrRouter.showAddShow()
            })
            .disposed(by: disposeBag)
    }

    func configureCollectionView() {
        collectionView.register(UINib(nibName: DvrShowCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: DvrShowCollectionViewCell.identifier)
        collectionView.dataSource = collectionViewModel
        collectionView.delegate = collectionViewModel
    }

    func applyViewModel() {
        viewModel.shows
            .subscribe(onNext: {
                if $0.count == 0 {
                    self.viewModel.refreshShowCache()
                }

                self.collectionViewModel.shows = $0
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
