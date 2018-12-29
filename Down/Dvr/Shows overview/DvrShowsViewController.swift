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

class DvrShowsViewController: UIViewController & Depending {
    typealias Dependencies = DvrShowsCollectionViewModel.Dependencies & RouterDependency & DvrApplicationDependency
    let dependencies: Dependencies
    
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

        configureCollectionView()
        applyStyling()
        bind(to: viewModel)
    }

    private func applyStyling() {
        view.style(as: .backgroundView)
    }

    private func configureCollectionView() {
        collectionViewModel = DvrShowsCollectionViewModel(dependencies: dependencies,
                                                          collectionView: collectionView)

        collectionViewModel.configure(collectionView)
    }
}

extension DvrShowsViewController: ReactiveBinding {
    typealias Bindable = DvrShowsViewModel

    func bind(output: DvrShowsViewModel.Output) {
        output.shows
            .drive(collectionViewModel.rx.shows)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .asObservable()
            .withLatestFrom(output.shows) { indexPath, shows in
                shows[indexPath.item]
            }
            .subscribe(onNext: {
                self.dependencies.router.dvrRouter.showDetail(of: $0)
            })
            .disposed(by: disposeBag)

        let showsLoaded = output.shows
            .map { !$0.isEmpty }

        showsLoaded
            .map { !$0 }
            .drive(collectionView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
