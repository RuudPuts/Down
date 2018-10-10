//
//  KeyValueTableViewCell.swift
//  Down
//
//  Created by Ruud Puts on 07/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class KeyValueTableViewCell: UITableViewCell {
    static let identifier = String(describing: DownloadItemCell.self)

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

//    var viewModel: DownloadItemCellModel? {
//        didSet {
//            keyLabel.text = viewModel?.keyLabel
//            valueLabel.text = viewModel?.valueLabel
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    func applyStyling() {
//        style(as: .keyValueCell)
    }
}
