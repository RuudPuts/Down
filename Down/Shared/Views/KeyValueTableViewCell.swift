//
//  KeyValueTableViewCell.swift
//  Down
//
//  Created by Ruud Puts on 07/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class KeyValueTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    func applyStyling() {
        keyLabel.style(as: .titleLabel)
        valueLabel.style(as: .detailLabel)
    }
}

extension KeyValueTableViewCell {
    func configure(with model: KeyValueCellModel) {
        keyLabel.text = model.keyText
        valueLabel.text = model.valueText
    }
}

protocol KeyValueCellModel {
    var keyText: String { get }
    var valueText: String { get }
}
