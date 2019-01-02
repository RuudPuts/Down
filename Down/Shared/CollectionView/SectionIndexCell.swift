//
//  SectionIndexCell.swift
//  Down
//
//  Created by Ruud Puts on 02/01/2019.
//  Copyright © 2019 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

class SectionIndexCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {
        style(as: .defaultCollectionViewCell)
        label.style(as: .annotationLabel)
    }
}

extension SectionIndexCell {
    func configure(with title: String) {
        label.text = title
    }
}
