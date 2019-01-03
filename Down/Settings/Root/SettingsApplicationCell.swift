//
//  SettingsApplicationCell.swift
//  Down
//
//  Created by Ruud Puts on 02/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

class SettingsApplicationCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!

    var viewModel: SettingsApplicationCellModel! {
        didSet {
            iconImageView.image = viewModel.icon
            statusLabel.text = viewModel.statusText
            statusLabel.style(as: viewModel.statusStyle)

            activeLabel.text = viewModel.activeText
            activeLabel.style(as: viewModel.activeStyle)
            activeLabel.isHidden = !viewModel.active
        }
    }
}

struct SettingsApplicationCellModel {
    var applicationType: DownApplicationType
    var configured: Bool
    var active: Bool

    var icon: UIImage {
        return AssetProvider.Icon.for(applicationType)
    }

    var statusText: String {
        return configured ? "Configured" : "Not configured"
    }

    var statusStyle: ViewStyling<UILabel> {
        return configured ? .greenDetailLabel : .redDetailLabel
    }

    var activeText: String {
        return "Active"
    }

    var activeStyle: ViewStyling<UILabel> {
        return .greenDetailLabel
    }
}
