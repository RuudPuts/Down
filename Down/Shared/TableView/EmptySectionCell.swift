//
//  EmptySectionCell.swift
//  Down
//
//  Created by Ruud Puts on 24/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class EmptySectionCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {
        style(as: .defaultTableViewCell)
        label.style(as: .detailLabel)
    }
}

extension EmptySectionCell {
    func configure(with message: String) {
        label.text = message
    }
}
