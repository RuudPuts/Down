//
//  NVActivityIndicatorFiewStyle.swift
//  Down
//
//  Created by Ruud Puts on 19/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import NVActivityIndicatorView
import DownKit

extension ViewStyling where ViewType == NVActivityIndicatorView {
    static var defaultActivityIndicator = ViewStyling {
        $0.type = .ballScaleRippleMultiple
        $0.color = Stylesheet.Colors.white
        $0.startAnimating()
    }

    static func activityIndicator(application: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.style(as: .defaultActivityIndicator)
            $0.stopAnimating()
            $0.color = Stylesheet.Colors.primaryColor(for: application)
            $0.startAnimating()
        }
    }
}
