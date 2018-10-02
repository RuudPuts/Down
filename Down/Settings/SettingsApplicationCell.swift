//
//  SettingsApplicationCell.swift
//  Down
//
//  Created by Ruud Puts on 02/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class SettingsApplicationCell: UITableViewCell {
    static let identifier = String(describing: SettingsApplicationCell.self)

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    var viewModel: SettingsApplicationCellModel? {
        didSet {
            nameLabel.text = viewModel?.name
            statusLabel.text = viewModel?.status
            statusLabel.isHidden = viewModel?.hideStatusLabel ?? true
            iconImageView.image = viewModel?.icon

            applyStyling()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    func applyStyling() {
        nameLabel.style(as: .titleLabel)
        statusLabel.style(as: viewModel?.statusStyle ?? .detailLabel)
    }
}

struct SettingsApplicationCellModel {
    var applicationType: DownApplicationType
    var isConfigured: Bool

    var name: String {
        return applicationType.displayName
    }

    var status: String? {
        return isConfigured ? "Not configured" : nil
    }

    var hideStatusLabel: Bool {
        return isConfigured
    }

    var statusStyle: ViewStyling<UILabel> {
        return .redDetailLabel
    }

    var icon: UIImage {
        return AssetProvider.icons.for(applicationType)
    }
}
