//
//  View.swift
//  StylingEngine
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == UIView {
    static var backgroundView = ViewStyling {
        $0.backgroundColor = Stylesheet.Colors.Backgrounds.darkBlue
        $0.subviews.forEach { $0.backgroundColor = .clear }
    }

    static func roundedView(_ radius: CGFloat) -> ViewStyling {
        return ViewStyling {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = radius
        }
    }

    static var contentView = ViewStyling {
        $0.backgroundColor = Stylesheet.Colors.Backgrounds.lightBlue
    }

    static var roundedContentView = ViewStyling {
        $0.style(as: .contentView)
        $0.style(as: .roundedView(5))
    }

    static var overlayView = ViewStyling {
        $0.backgroundColor = Stylesheet.Colors.black.withAlphaComponent(0.3)
    }
    }
}
