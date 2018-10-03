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

class DvrShowsCollectionViewModel: NSObject {
    var interactorFactory: DvrInteractorProducing
    var shows: [DvrShow]?
    var imageCache = NSCache<NSString, UIImage>()
    weak var collectionView: UICollectionView?
    weak var router: DvrRouter?
    weak var application: DvrApplication?
    let disposeBag = DisposeBag()

    init(collectionView: UICollectionView, router: DvrRouter?, application: DvrApplication?, interactorFactory: DvrInteractorProducing) {
        self.collectionView = collectionView
        self.router = router
        self.application = application
        self.interactorFactory = interactorFactory
    }

    func configure(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: DvrShowCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: DvrShowCollectionViewCell.identifier)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 30)
        }

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }
}

extension DvrShowsCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let show = shows?[indexPath.item],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DvrShowCollectionViewCell.identifier,
                                                                          for: indexPath) as? DvrShowCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.viewModel = DvrShowCellModel(title: show.name,
                                          image: image(for: show))

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

        router?.showDetail(of: show)
    }
}

extension DvrShowsCollectionViewModel: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            guard let show = shows?[$0.item] else {
                return
            }

            _ = image(for: show)
        }
    }
}

extension DvrShowsCollectionViewModel {
    func indexPath(for show: DvrShow) -> IndexPath {
        return IndexPath(item: shows?.index(of: show) ?? NSNotFound, section: 0)
    }

    func image(for show: DvrShow) -> UIImage {
        if let image = imageCache.object(forKey: show.identifier as NSString) {
            return image
        }

        fetchPoster(for: show)

        return UIImage()
    }

    func fetchPoster(for show: DvrShow) {
        guard let collectionView = collectionView else {
            return
        }

        let size = self.collectionView(collectionView,
                                       layout: UICollectionViewFlowLayout(),
                                       sizeForItemAt: IndexPath(item: 0, section: 0))

        interactorFactory
            .makeShowPosterInteractor(for: application!, show: show)
            .observe()
            .map { $0.scaled(to: size) }
            .subscribe(onNext: { $0
                self.imageCache.setObject($0, forKey: show.identifier as NSString)
                self.collectionView?.reloadItems(at: [self.indexPath(for: show)])
            })
            .disposed(by: disposeBag)
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
