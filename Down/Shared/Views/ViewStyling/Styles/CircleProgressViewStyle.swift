//
//  CircleProgressViewStyle.swift
//  Down
//
//  Created by Ruud Puts on 15/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import CircleProgressView

extension ViewStyling where ViewType == CircleProgressView {
    static var `defaultProgressView` = ViewStyling {
        $0.backgroundColor = .clear
        $0.centerFillColor = Stylesheet.Colors.Backgrounds.lightBlue
        $0.trackBackgroundColor = Stylesheet.Colors.Backgrounds.darkBlue
        $0.trackFillColor = UIColor.orange.withAlphaComponent(0.8)

        $0.trackWidth = 5
    }
}
