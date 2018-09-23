//
//  SkyFloatingLabelTextFieldStyle.swift
//  StylingEngine
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import SkyFloatingLabelTextField

extension ViewStyling where ViewType == SkyFloatingLabelTextField {
    static var defaultTextField = ViewStyling {
        $0.textColor = Stylesheet.Colors.white
    }

    static func textField(for type: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.style(as: .defaultTextField)

            $0.titleColor = Stylesheet.Colors.primaryColor(for: type)
            $0.selectedTitleColor = Stylesheet.Colors.primaryColor(for: type)

            $0.lineColor = Stylesheet.Colors.white
            $0.lineHeight = 1

            $0.selectedLineColor = Stylesheet.Colors.primaryColor(for: type)
            $0.selectedLineHeight = 2
        }
    }
}
