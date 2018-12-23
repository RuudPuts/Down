//
//  UITextFieldStyle.swift
//  Down
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import DownKit

extension ViewStyling where ViewType == UITextField {
    static var defaultTextField = ViewStyling {
        $0.textColor = Stylesheet.Colors.white
    }

    static func textField(for type: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.style(as: .defaultTextField)
        }
    }
}
