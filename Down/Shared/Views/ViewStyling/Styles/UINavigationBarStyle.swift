//
//  UINavigationBarStyle.swift
//  Down
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == UINavigationBar {
    static var defaultNavigationBar = ViewStyling {
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true

        $0.tintColor = Stylesheet.Colors.white
        $0.titleTextAttributes = [
            .font: Stylesheet.Fonts.largeHeaderFont,
            .foregroundColor: Stylesheet.Colors.white
        ]
    }
}
