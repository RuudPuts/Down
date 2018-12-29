//
//  UITabBarStyle.swift
//  Down
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == UITabBar {
    static var defaultTabBar = ViewStyling {
        $0.barTintColor = Stylesheet.Colors.Backgrounds.darkBlue
        $0.tintColor = Stylesheet.Colors.white

        $0.items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }

        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    }
}
