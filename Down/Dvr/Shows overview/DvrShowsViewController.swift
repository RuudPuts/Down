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
    @IBOutlet weak var sectionIndexView: SectionIndexView!

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

        sectionIndexView.applicationType = dependencies.dvrApplication.downType
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

        let showsEmpty = output.shows.map { $0.isEmpty }

        showsEmpty
            .drive(collectionView.rx.isHidden)
            .disposed(by: disposeBag)

        output.shows
            .map { $0.map { $0.name } }
            .drive(sectionIndexView.rx.dataSource)
            .disposed(by: disposeBag)

        sectionIndexView.rx.indexSelected
            .map { $0.lowercased() }
            .withLatestFrom(output.shows) { index, shows in
                shows.firstIndex(where: { $0.name.lowercased().starts(with: index) }) ?? 0
            }
            .subscribe(onNext: {
                let indexPath = IndexPath(item: $0, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            })
            .disposed(by: disposeBag)

        showsEmpty
            .drive(sectionIndexView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
