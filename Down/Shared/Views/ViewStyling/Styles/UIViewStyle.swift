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

    static var cellContentView = ViewStyling {
        $0.backgroundColor = Stylesheet.Colors.Backgrounds.lightBlue
        $0.layer.cornerRadius = 5
    }
}
