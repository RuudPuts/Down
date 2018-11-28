//
//  SkyFloatingLabelTextFieldStyle.swift
//  Down
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import DownKit
import SkyFloatingLabelTextField

extension ViewStyling where ViewType == SkyFloatingLabelTextField {
    static func floatingLabelTextField(for type: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.style(as: .textField(for: type))

            $0.titleColor = Stylesheet.Colors.primaryColor(for: type)
            $0.selectedTitleColor = Stylesheet.Colors.primaryColor(for: type)

            $0.lineColor = Stylesheet.Colors.white
            $0.lineHeight = 1

            $0.selectedLineColor = Stylesheet.Colors.primaryColor(for: type)
            $0.selectedLineHeight = 2
        }
    }
}
