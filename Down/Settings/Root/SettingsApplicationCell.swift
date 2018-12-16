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

    var viewModel: SettingsApplicationCellModel? {
        didSet {
            iconImageView.image = viewModel?.icon
        }
    }
}

struct SettingsApplicationCellModel {
    var applicationType: DownApplicationType

    var icon: UIImage {
        return AssetProvider.Icon.for(applicationType)
    }
}
