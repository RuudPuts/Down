//
//  DvrShowCollectionViewCell.swift
//  Down
//
//  Created by Ruud Puts on 27/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class DvrShowCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    var viewModel: DvrShowCellModel? {
        didSet {
            textLabel.text = viewModel?.title
            imageView.image = viewModel?.image
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.style(as: .roundedContentView)
        textLabel.style(as: .titleLabel)
    }
}

struct DvrShowCellModel {
    var title: String
    var image: UIImage
}
