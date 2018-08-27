//
//  UIButtonStyle.swift
//  Down
//
//  Created by Ruud Puts on 14/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == UIButton {
    static var successButton = ViewStyling {
        $0.style(as: .contentView)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Stylesheet.Fonts.regularFont(ofSize: 14)
        $0.backgroundColor = Stylesheet.Colors.green
    }

    static var deleteButton = ViewStyling {
        $0.style(as: .contentView)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Stylesheet.Fonts.regularFont(ofSize: 14)
        $0.backgroundColor = Stylesheet.Colors.green
    }

    static var cancelButton = ViewStyling {
        $0.style(as: .contentView)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Stylesheet.Fonts.regularFont(ofSize: 14)
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
}
