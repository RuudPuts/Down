//
//  DvrShowsViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class DvrShowsViewController: UIViewController & Depending {
    typealias Dependencies = DvrShowsCollectionViewModel.Dependencies & RouterDependency & DvrApplicationDependency
    let dependencies: Dependencies

    @IBOutlet weak var activityContainer: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!

    private let viewModel: DvrShowsViewModel
    private var collectionViewModel: DvrShowsCollectionViewModel!

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies, viewModel: DvrShowsViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewModel = DvrShowsCollectionViewModel(dependencies: dependencies,
                                                          collectionView: collectionView)

        configureCollectionView()
        applyStyling()
        bind(to: viewModel)
    }

    private func applyStyling() {
        view.style(as: .backgroundView)

        activityLabel.style(as: .titleLabel)
        activityIndicator.style(as: .activityIndicator(application: dependencies.dvrApplication.downType))
    }

    private func configureCollectionView() {
        collectionViewModel.configure(collectionView)
        createCollectionHeaderView()
    }

    private func createCollectionHeaderView() {
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
}

extension DvrShowsViewController: ReactiveBinding {
    func makeInput() -> DvrShowsViewModel.Input {
        return DvrShowsViewModel.Input()
    }

    func bind(to viewModel: DvrShowsViewModel) {
        let output = viewModel.transform(input: makeInput())

        output.refreshShowCache
            .subscribe()
            .disposed(by: disposeBag)

        output.shows
            .drive(collectionViewModel.rx.shows)
            .disposed(by: disposeBag)

        let showsLoaded = output.shows
            .map { !$0.isEmpty }

        showsLoaded
            .drive(activityContainer.rx.isHidden)
            .disposed(by: disposeBag)

        showsLoaded
            .map { !$0 }
            .drive(collectionView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
