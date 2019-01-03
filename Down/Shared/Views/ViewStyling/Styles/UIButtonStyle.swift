//
//  UIButtonStyle.swift
//  Down
//
//  Created by Ruud Puts on 14/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

extension ViewStyling where ViewType == UIButton {
    static var defaultButton = ViewStyling {
        $0.style(as: .roundedView(4))

        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Stylesheet.Fonts.boldFont(ofSize: 14)
    }
    static var successButton = ViewStyling {
        $0.style(as: .defaultButton)
        $0.style(as: .contentView)
        $0.backgroundColor = Stylesheet.Colors.green
    }

    static var deleteButton = ViewStyling {
        $0.style(as: .defaultButton)
        $0.backgroundColor = Stylesheet.Colors.red
    }

    static var cancelButton = ViewStyling {
        $0.style(as: .defaultButton)
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    static func applicationButton(_ type: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.style(as: .defaultButton)
            $0.backgroundColor = Stylesheet.Colors.primaryColor(for: type)
        }
    }

    static func contextButton(for type: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.style(as: .defaultButton)

            let image = R.image.icon_context()?.withRenderingMode(.alwaysTemplate)
            $0.setImage(image, for: .normal)
            $0.tintColor = Stylesheet.Colors.primaryColor(for: type)
        }
    }
}
