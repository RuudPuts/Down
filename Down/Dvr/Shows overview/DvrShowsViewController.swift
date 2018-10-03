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
        let button = UIButton()
        button.setTitle("Add show", for: .normal)
        button.style(as: .successButton)
        button.translatesAutoresizingMaskIntoConstraints = false

        collectionView.addSubview(button)

        button.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
        button.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true

        button.rx.tap
            .subscribe(onNext: { _ in
                self.router?.dvrRouter.showAddShow()
            })
            .disposed(by: disposeBag)
    }

    func applyViewModel() {
        viewModel.shows
            .subscribe(onNext: {
//                if $0.count == 0 {
//                    self.viewModel.refreshShowCache()
//                }

                self.collectionViewModel.shows = $0
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
