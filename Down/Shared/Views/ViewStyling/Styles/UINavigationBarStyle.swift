//
//  UITabBarStyle.swift
//  StylingEngine
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == UINavigationBar {
    static var transparentNavigationBar = ViewStyling {
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
        $0.tintColor = Stylesheet.Colors.white
    }
}
