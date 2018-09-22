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
    
    static var overlayView = ViewStyling {
        $0.backgroundColor = Stylesheet.Colors.black.withAlphaComponent(0.3)
    }

    static var fadingOverlayView = ViewStyling {
//        $0.backgroundColor = Stylesheet.Colors.black.withAlphaComponent(0.3)
        let gradient = CAGradientLayer()

        gradient.frame = $0.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
    }
}
