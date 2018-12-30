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
}

extension ActivityView {
    func configure(for application: DownApplicationType) {
        label.isHidden = true

        activityIndicator.style(as: .activityIndicator(application: application))
    }

    func configure(with text: String, application: DownApplicationType) {
        configure(for: application)

        label.text = text
        label.isHidden = text.isEmpty
    }
}
