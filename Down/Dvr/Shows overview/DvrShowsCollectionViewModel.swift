//
//  DvrShowsCollectionViewModel.swift
//  Down
//
//  Created by Ruud Puts on 27/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa

class DvrShowsCollectionViewModel: NSObject, Depending {
    typealias Dependencies = DvrApplicationDependency & DvrRequestBuilderDependency
    let dependencies: Dependencies

    var shows: [DvrShow]? {
        didSet {
            collectionView?.reloadData()
        }
    }

    private weak var collectionView: UICollectionView?
    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies, collectionView: UICollectionView) {
        self.dependencies = dependencies
        self.collectionView = collectionView
    }

    func configure(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: DvrShowCollectionViewCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: DvrShowCollectionViewCell.reuseIdentifier)

        collectionView.contentInset = UIEdgeInsets(top: -8, left: 0, bottom: 0, right: -4)

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension Reactive where Base: DvrShowsCollectionViewModel {
    var shows: Binder<[DvrShow]> {
        return Binder(base) { collectionViewModel, shows in
            collectionViewModel.shows = shows
        }
    }
}

extension DvrShowsCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let show = shows?[indexPath.item],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DvrShowCollectionViewCell.reuseIdentifier,
                                                                          for: indexPath) as? DvrShowCollectionViewCell else {
            return UICollectionViewCell()
        }

        let imageUrl = dependencies.dvrRequestBuilder.url(for: .fetchPoster(show))
        cell.viewModel = DvrShowCellModel(title: show.name,
                                          imageUrl: imageUrl)

        return cell
    }
}

extension DvrShowsCollectionViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedWidth: CGFloat = 170
        let itemsPerRow = max(3, floor(collectionView.bounds.width / estimatedWidth))

        let width = collectionView.bounds.width / itemsPerRow
        return CGSize(width: width, height: width * 1.7)
    }
}

extension DvrShowsCollectionViewModel {
    func indexPath(for show: DvrShow) -> IndexPath {
        return IndexPath(item: shows?.index(of: show) ?? NSNotFound, section: 0)
    }
}
