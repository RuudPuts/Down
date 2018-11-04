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
    typealias Dependencies = RouterDependency & DvrApplicationDependency & DvrRequestBuilderDependency
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

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 30)
        }

        collectionView.dataSource = self
        collectionView.delegate = self
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
        let width = round(collectionView.bounds.width / 3)
        return CGSize(width: width, height: width * 1.7)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let show = shows?[indexPath.item] else {
            return
        }

        dependencies.router.dvrRouter.showDetail(of: show)
    }
}

extension DvrShowsCollectionViewModel {
    func indexPath(for show: DvrShow) -> IndexPath {
        return IndexPath(item: shows?.index(of: show) ?? NSNotFound, section: 0)
    }
}

//extension Reactive where Base: DvrShowsCollectionViewModel {
//    var shows: ControlProperty<[DvrShow]?> {
//        let source: Observable<[DvrShow]?> = Observable.deferred { [weak model = self.base as DvrShowsCollectionViewModel] () -> Observable<[DvrShow]?> in
//            return Observable.just(model?.shows)
//        }
//
//        let bindingObserver = Binder(self.base) { (model, shows: [DvrShow]?) in
//            model.shows = shows
//        }
//
//        return ControlProperty(values: source, valueSink: bindingObserver)
//    }
//}
