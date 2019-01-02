//
//  SectionIndexView.swift
//  Down
//
//  Created by Ruud Puts on 02/01/2019.
//  Copyright © 2019 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa

class SectionIndexView: DesignableView {
    private let symbolSectionTitle = "#"
    private let symbolPrefixes = ["'", "\\", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    @IBOutlet weak var collectionView: UICollectionView!

    var applicationType: DownApplicationType?
    fileprivate let selectedIndexPath = PublishSubject<IndexPath>()
    fileprivate var gestureRecognizer: UIPanGestureRecognizer!

    fileprivate var dataSource = [String]() {
        didSet {
            let cellsHeight = CGFloat(dataSource.count) * bounds.width
            collectionView.heightConstraint?.constant = cellsHeight
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
        prepareCollectionView()
        prepareGestureRecognizer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: bounds.width, height: bounds.width)
        }
    }

    private func applyStyling() {
        style(as: .backgroundView)
    }

    private func prepareCollectionView() {
        collectionView.registerCell(nibName: SectionIndexCell.reuseIdentifier)
    }

    private func prepareGestureRecognizer() {
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(_:)))
        collectionView.addGestureRecognizer(gestureRecognizer)
    }
}

@objc extension SectionIndexView {
    func handleGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        var touch = recognizer.location(in: collectionView)
        touch.x = self.bounds.midX

        if let indexPath = collectionView.indexPathForItem(at: touch) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            selectedIndexPath.onNext(indexPath)
        }

        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
            recognizer.state == .ended {
            collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
}

extension SectionIndexView {
    func configure(with dataSource: [String]) {
        self.dataSource = dataSource.compactMap { input -> String? in
                guard let firstChar = input.first else {
                    return nil
                }

                let title = String(firstChar)

                if symbolPrefixes.contains(title) {
                    return symbolSectionTitle
                }

                return title
            }
            .unique()
            .sorted { $0 < $1 }
    }
}

extension SectionIndexView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionIndexCell.reuseIdentifier, for: indexPath)

        guard let indexCell = cell as? SectionIndexCell else {
            return UICollectionViewCell()
        }

        indexCell.configure(with: dataSource[indexPath.item])
//        indexCell.backgroundColor = .red

        return indexCell
    }
}

extension SectionIndexView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let applicationType = applicationType else {
            return
        }

        cell.style(as: .selectableCollectionViewCell(application: applicationType))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath.onNext(indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension Reactive where Base: SectionIndexView {
    var dataSource: Binder<[String]> {
        return Binder(base) { indexView, dataSource in
            indexView.configure(with: dataSource)
        }
    }

    var indexSelected: Observable<String> {
        return Observable.merge(base.selectedIndexPath)
            .map { self.base.dataSource[$0.item] }
    }
}
