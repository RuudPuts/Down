//
//  UITabBarStyle.swift
//  StylingEngine
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == UITabBar {
    static var `defaultTabBar` = ViewStyling { (tabBar: UITabBar) in
        tabBar.barTintColor = Stylesheet.Colors.Backgrounds.darkBlue
        tabBar.tintColor = .white

        tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}
