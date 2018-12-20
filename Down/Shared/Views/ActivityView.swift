//
//  ActivityView.swift
//  Down
//
//  Created by Ruud Puts on 20/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import DownKit

class ActivityView: DesignableView {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {
        label.style(as: .titleLabel)
        activityIndicator.style(as: .defaultActivityIndicator)
    }

    func configure(with text: String, application: DownApplicationType) {
        label.text = text

        activityIndicator.style(as: .activityIndicator(application: application))
    }
}
