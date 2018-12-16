//
//  UICollectionViewExtensions.swift
//  Down
//
//  Created by Ruud Puts on 06/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension UICollectionView {
    var collectionHeaderView: UIView? {
        get {
            return subviews.first(where: { !$0.isKind(of: UICollectionViewCell.self) })
        }
        set {
            collectionHeaderView?.removeFromSuperview()

            guard let headerView = newValue else {
                return
            }

            headerView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(headerView)

            headerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
    }
}
